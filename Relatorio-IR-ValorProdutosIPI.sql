SELECT 		SUM(TOTAL1) AS TOTAL1,
			SUM(TOTAL2) AS TOTAL2,
			SUM(TOTAL3) AS TOTAL3,
			CODEMP AS EMPRESA,
			DESCRGRUPOPROD AS CATEGORIA

FROM (

SELECT
SUM(CAB.VLRNOTA - CAB.VLRIPI - VLRSUBST) AS TOTAL1, 0 AS TOTAL2, 0 AS TOTAL3,
CAB.CODEMP, GRU.DESCRGRUPOPROD

FROM TGFCAB CAB

join TGFVEN VEN on CAB.CODVEND = VEN.CODVEND
join TGFITE ITE on CAB.NUNOTA = ITE.NUNOTA
join TGFPRO PRO on ITE.CODPROD = PRO.CODPROD
join TGFGRU GRU on PRO.CODGRUPOPROD = GRU.CODGRUPOPROD

	WHERE CAB.TIPMOV = 'V'
	AND CAB.CODEMP = 1
	AND CAB.CODTIPOPER IN(1100,1118,1123,1126,1127,2200,2201,1131)
	AND (VEN.CODVEND = :P_VENDEDOR OR :P_VENDEDOR IS NULL )
	AND CAB.DTMOV BETWEEN :P_PERIODO.INI AND :P_PERIODO.FIN
	

GROUP BY CAB.CODEMP, DESCRGRUPOPROD

--============================================================================
--============================================================================

UNION ALL

--============================================================================
--============================================================================

SELECT
			0 AS TOTAL1, SUM(CAB.VLRNOTA - CAB.VLRIPI - VLRSUBST) AS TOTAL2, 0 AS TOTAL3,
				CAB.CODEMP, GRU.DESCRGRUPOPROD


FROM TGFCAB CAB

join TGFVEN VEN on CAB.CODVEND = VEN.CODVEND
join TGFITE ITE on CAB.NUNOTA = ITE.NUNOTA
join TGFPRO PRO on ITE.CODPROD = PRO.CODPROD
join TGFGRU GRU on PRO.CODGRUPOPROD = GRU.CODGRUPOPROD

	WHERE CAB.TIPMOV = 'P'
	AND CAB.PENDENTE = 'S' AND CODTIPOPER IN (1000,1008,1009,1216,1235,1245,2500,2223,2221,1232,1233,1221,1241,1244,1223,1240,1251,1255,1256,1250,1260,2501,1252)
	AND (VEN.CODVEND = :P_VENDEDOR OR :P_VENDEDOR IS NULL )
	AND  CAB.DTMOV BETWEEN :P_PERIODO2.INI AND :P_PERIODO2.FIN

GROUP BY CAB.CODEMP, DESCRGRUPOPROD

--============================================================================
--============================================================================

UNION ALL

--============================================================================
--============================================================================

SELECT
			0 AS TOTAL1, 0 AS TOTAL2, SUM(CAB.VLRNOTA - CAB.VLRIPI - VLRSUBST) AS TOTAL3,
				CAB.CODEMP, GRU.DESCRGRUPOPROD


FROM TGFCAB CAB

join TGFVEN VEN on CAB.CODVEND = VEN.CODVEND
join TGFITE ITE on CAB.NUNOTA = ITE.NUNOTA
join TGFPRO PRO on ITE.CODPROD = PRO.CODPROD
join TGFGRU GRU on PRO.CODGRUPOPROD = GRU.CODGRUPOPROD

	WHERE
     CAB.DTMOV BETWEEN :P_PERIODO.INI AND :P_PERIODO.FIN
AND (CAB.TIPMOV = 'V'
AND CAB.CODTIPOPER IN(1100,1118,1123,1126,1127,2200,2201,1131)
AND (VEN.CODVEND = :P_VENDEDOR OR :P_VENDEDOR IS NULL ) 
OR (CAB.TIPMOV = 'P'
AND  CAB.DTMOV BETWEEN :P_PERIODO2.INI AND :P_PERIODO2.FIN
AND CAB.PENDENTE = 'S'
AND (VEN.CODVEND = :P_VENDEDOR OR :P_VENDEDOR IS NULL ) 
AND CODTIPOPER IN (1000,1008,1009,1216,1235,1245,2500,2223,2221,1232,1233,1221,1241,1244,1223,1240,1251,1255,1256,1250,1260,2501,1252)))

GROUP BY CAB.CODEMP, DESCRGRUPOPROD

) A

GROUP BY CODEMP, DESCRGRUPOPROD
ORDER BY 1 DESC