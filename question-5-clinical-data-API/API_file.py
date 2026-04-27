from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import pandas as pd

# -------------------------------
# Load Data (once at startup)
# -------------------------------
adae = pd.read_csv("adae.csv")

# Ensure consistent casing
adae["AESEV"] = adae["AESEV"].str.upper()
adae["ACTARM"] = adae["ACTARM"].str.upper()

# -------------------------------
# FastAPI App
# -------------------------------
app = FastAPI(
    title="Clinical Trial Data API",
    description="API for querying adverse event data and calculating subject safety risk scores.",
    version="1.0.0"
)

# -------------------------------
# Request Model for Filtering
# -------------------------------
class AEQuery(BaseModel):
    AESEV: list[str] | None = None
    ACTARM: str | None = None


# -------------------------------
# 1. Root Endpoint
# -------------------------------
@app.get("/")
def root():
    return {"message": "Clinical Trial Data API is running"}


# -------------------------------
# 2. Dynamic Filtering Endpoint
# -------------------------------
@app.post("/ae-query")
def ae_query(query: AEQuery):

    df = adae.copy()

    # Apply severity filter (if provided)
    if query.AESEV:
        severities = [s.upper() for s in query.AESEV]
        df = df[df["AESEV"].isin(severities)]

    # Apply treatment filter (if provided)
    if query.ACTARM:
        df = df[df["ACTARM"] == query.ACTARM.upper()]

    return {
        "record_count": len(df),
        "unique_subjects": df["USUBJID"].dropna().unique().tolist()
    }


# -------------------------------
# 3. Risk Score Endpoint
# -------------------------------
@app.get("/subject-risk/{subject_id}")
def subject_risk(subject_id: str):

    df = adae[adae["USUBJID"].str.upper() == subject_id.upper()]

    if df.empty:
        raise HTTPException(status_code=404, detail="Subject not found")

    # Severity scoring
    score_map = {
        "MILD": 1,
        "MODERATE": 3,
        "SEVERE": 5
    }
    
    df=df.copy()
    df["score"] = df["AESEV"].map(score_map).fillna(0)

    risk_score = int(df["score"].sum())

    # Risk category
    if risk_score < 5:
        category = "Low"
    elif risk_score < 15:
        category = "Medium"
    else:
        category = "High"

    return {
        "subject_id": subject_id,
        "risk_score": risk_score,
        "risk_category": category
    }
