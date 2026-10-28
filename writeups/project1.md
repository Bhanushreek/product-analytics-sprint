# Project 1: Failed UPI Payment Recovery

An independent product requirements project about what users need to know and do after a UPI payment fails or stays pending.

## Problem

After a UPI payment fails or remains pending, users may not know whether money was deducted or what to do next. They may retry, switch payment methods, wait, or contact support without knowing whether the original payment will complete.

**Scope:** A generic UPI app, informed by public signals about PhonePe, Google Pay, and Paytm. This is an independent analysis; it does not claim access to internal company data.

## Evidence

- Reviewed **19 public review and Reddit records** about failed, pending, debited, or delayed UPI payments.
- Collected **two anonymous interviews** about past payment experiences.
- The evidence is directional: it is a small, self-collected sample, not a representative study.

## User need

When a UPI payment fails or stays pending at checkout, users want to know whether their money is safe and what to do next, so they can complete the purchase without paying twice or losing money.

## Proposed solution

A payment status and recovery screen for failed or pending payments. The concept includes a clear status and deduction message, a reference ID, plain-language error guidance, safe retry options, another linked bank account, status updates, and a final-status notification.

V1 focuses on payment clarity and recovery. Dispute management, compensation, and cross-app coordination are out of scope.

## Success measures

- **North star — Recovery rate:** eligible failed or pending payments that lead to a successful payment for the same order within 30 minutes.
- **Secondary:** time to resolution, failed-payment support contact rate, and first-retry success rate.
- **Guardrail:** duplicate payment rate must not materially increase.

The real baseline is unknown. The A/B test design uses an assumed 60% baseline recovery rate and a 3 percentage-point minimum detectable effect; both are assumptions, not company data.

## Prioritisation and experiment

The RICE table compares status clarity, one-tap retry, retrying with another bank account, push notifications, and an AI retry recommender. The scores are planning assumptions. The AI feature is a later idea because it has lower confidence and higher effort.

The A/B test compares the current failure screen with the proposed recovery screen. It randomises by user and measures each user’s first eligible failed or pending payment. The planned sample size is about 4,200 users per group, based on the assumed baseline and effect size.

## AI extension

A future model could recommend whether to retry now, wait, or switch accounts using technical signals such as failure code, bank, time, network type, and device type. It would only suggest an action; it would never retry automatically. A rules-based fallback would be used when confidence is low.

## Limitations

- Evidence consists of 19 public reports and two interviews; it may not represent all UPI users.
- No internal payment logs or company baseline were available.
- Metrics, RICE inputs, and A/B test inputs are assumptions where stated.
- Wireframes are not included in this portfolio version.

## Project materials

- [Full PRD in Notion](https://app.notion.com/p/Project-1-Failed-UPI-Payment-Recovery-402de3c59ad1808a986ec671d9cf7708?source=copy_link)
- [Evidence log in Google Sheets](https://docs.google.com/spreadsheets/d/1nOlpOy5mSdM5L7qP7r0xfMoVcY-vcywGS11pGCbIKkY/edit?usp=sharing)
