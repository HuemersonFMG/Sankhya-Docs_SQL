SELECT VAR.NUNOTAORIG, CAB.NUNOTA PEDIDO, CAB.CODTIPOPER, CAB.TIPMOV, CAB.ORDEMCARGA OC,
        CASE  CAB.MODENTREGA 
            WHEN 'A'  THEN 'AUTO DISTRIBUIÇÃO'
            WHEN 'N'  THEN 'ENTREGA DIRETA'
            WHEN 'M'  THEN 'MULTI ENTREGA'
            WHEN 'F'  THEN 'ME FATURAR PARA'
            WHEN 'P'  THEN 'PORTA A PORTA'
            WHEN 'S'  THEN 'SEM ENTREGA'
            ELSE '' END AS MODENT,
        PRO.CODPROD MODELO, PRO.DESCRPROD DESCMOD, PRO.MARGLUCRO MKP, PRO.ATIVO, PRO.DTALTER ALTERADO, PRO.CODLOCALPADRAO LOCAL, 
        CASE WHEN (CAB.CODTIPOPER = 1100) OR (CAB.CODTIPOPER = 1124) THEN CAB.QTDVOL ELSE 0 END AS QTDPED,
        CASE WHEN (CAB.CODTIPOPER = 1100) OR (CAB.CODTIPOPER = 1124) AND CAB.STATUSNOTA = 'L' THEN CAB.QTDVOL ELSE 0 END AS FATURADO,
        (CASE WHEN (CAB.CODTIPOPER = 1100) OR (CAB.CODTIPOPER = 1124) THEN CAB.QTDVOL ELSE 0 END) - 
        (CASE WHEN (CAB.CODTIPOPER = 1100) OR (CAB.CODTIPOPER = 1124) AND CAB.STATUSNOTA = 'L' THEN CAB.QTDVOL ELSE 0 END) DISPONIVEL,
        CAB.STATUSNFE, CAB.VLRNOTA,
        SUM(CAB.VLRNOTA) AS VLRESTDISP,
        (CAB.VLRNOTA / CAB.QTDVOL) VLRUNIT
FROM TGFPRO PRO
LEFT JOIN TGFEST EST ON EST.CODPROD = PRO.CODPROD
LEFT JOIN TGFITE ITE ON ITE.CODPROD = PRO.CODPROD
LEFT JOIN TGFCAB CAB ON CAB.NUNOTA = ITE.NUNOTA
LEFT JOIN TGFVAR VAR ON VAR.NUNOTA = CAB.NUNOTA
WHERE PRO.AD_CESTA = 'S'
AND CAB.DTNEG >= '01/10/2023'
AND VAR.NUNOTAORIG IN (73764,77388,76383)
AND CAB.CODTIPOPER IN (1100, 1117, 1124, 1112)
--AND (CAB.ORDEMCARGA = 0 OR CAB.ORDEMCARGA IS NULL)
AND CAB.TIPMOV = 'V'
AND CAB.MODENTREGA <> 'P'
--AND CAB.MODENTREGA <> 'S'
AND CAB.CODEMP = 1

GROUP BY CAB.TIPMOV, PRO.CODPROD, PRO.DESCRPROD, PRO.MARGLUCRO, PRO.ATIVO, PRO.DTALTER, PRO.CODLOCALPADRAO, CAB.NUNOTA, 
        CAB.QTDVOL, CAB.VLRNOTA, CAB.MODENTREGA, CAB.ORDEMCARGA, CAB.CODTIPOPER, CAB.STATUSNOTA, VAR.NUNOTAORIG,CAB.STATUSNFE
ORDER BY PEDIDO ASC
