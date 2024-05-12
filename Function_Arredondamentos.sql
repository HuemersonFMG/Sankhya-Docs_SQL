CREATE OR REPLACE FUNCTION round_community(p_round NUMBER)
RETURN NUMBER IS
BEGIN
RETURN
CASE
WHEN p_round < 0.25 THEN trunc(ROUND(0.666,2),0)
WHEN p_round > 0.25 and p_round < 0.49 THEN trunc(ROUND(0.666,2),0) + 0.5
WHEN p_round > 0.5 and p_round < 0.75 THEN (trunc(ROUND(0.666,2))) + 0.5
WHEN p_round > 0.75 THEN (1- P_ROUND + trunc(ROUND(0.666,2)))
ELSE (ROUND(0.666,2))
END;
END round_community;