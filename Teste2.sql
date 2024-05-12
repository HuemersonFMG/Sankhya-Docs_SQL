SELECT CODPARC, NOMEPARC,  SUM(VALORANT) AS VALORANT, SUM(VALORAT) AS VALORAT ,
    case when sum(valorant)>0 then ((sum(VALORAT)/ SUM(VALORANT))-1)*100 end AS CRESCEU,
    (CASE WHEN SUM(VALORAT) >= SUM(VALORANT) THEN 'Cresceu' ELSE 'Diminuiu' END) AS AT
    FROM 
    (SELECT
    SUM (   ((  (ITE.VLRTOT)
            - (CASE WHEN :DESC = 'S' THEN ITE.VLRDESC ELSE 0 END)
            - (CASE WHEN :REP = 'S' THEN ITE.VLRREPRED ELSE 0 END)
            + (CASE WHEN :ST = 'S' THEN ITE.VLRSUBST ELSE 0 END)
                    + (CASE WHEN :IPI = 'S' THEN ITE.VLRIPI ELSE 0 END)
                        )
                    * CASE WHEN CAB.TIPMOV = 'D' THEN -1 ELSE 1 END) * VCAB.INDITENS
                ) AS VALORANT, 0 AS VALORAT,
    PAR.NOMEPARC, PAR.CODPARC
    FROM TGFCAB CAB
    , TGFPAR PAR
    , TGFITE ITE
    , TGFPRO PRO
    , TGFGRU GRU 
    , TGFTOP TPO
    , VGFCAB VCAB
    , TGFVEN VEN 
    WHERE (CAB.STATUSNOTA = 'L' OR :STATUSNOTA = 'N')
    AND ITE.USOPROD <> 'D'
    AND TPO.GOLSINAL= -1
    AND CAB.CODVEND= VEN.CODVEND
    AND VCAB.NUNOTA= CAB.NUNOTA
    AND PRO.CODGRUPOPROD= GRU.CODGRUPOPROD
    AND ((TPO.GRUPO IN :TOP))  
    AND CAB.CODEMP IN :EMPRESA
    AND CAB.DTNEG BETWEEN :PERIODO.INI AND :PERIODO.FIN AND CAB.CODEMP IN :EMPRESA
    AND ((PRO.CODPROD= :PRODUTO) OR (:PRODUTO IS NULL))
    AND ((CAB.CODPARC= :CODPARC) OR (:CODPARC IS NULL))
    AND ((CAB.CODVEND= :VENDEDOR) OR (:VENDEDOR IS NULL))
    AND ((PRO.CODGRUPOPROD= :GRUPO) OR (:GRUPO IS NULL))
    AND CAB.CODPARC = PAR.CODPARC
    AND CAB.NUNOTA = ITE.NUNOTA
    AND ITE.CODPROD = PRO.CODPROD
    AND CAB.CODTIPOPER = TPO.CODTIPOPER
    AND CAB.DHTIPOPER = TPO.DHALTER
    GROUP BY PAR.NOMEPARC, PAR.CODPARC
    
    UNION ALL
    
    SELECT
    0 AS VALORANT, 
    SUM (   ((  (ITE.VLRTOT)
            - (CASE WHEN :DESC = 'S' THEN ITE.VLRDESC ELSE 0 END)
            - (CASE WHEN :REP = 'S' THEN ITE.VLRREPRED ELSE 0 END)
            + (CASE WHEN :ST = 'S' THEN ITE.VLRSUBST ELSE 0 END)
                    + (CASE WHEN :IPI = 'S' THEN ITE.VLRIPI ELSE 0 END)
                        )
                    * CASE WHEN CAB.TIPMOV = 'D' THEN -1 ELSE 1 END) * VCAB.INDITENS
                ) AS VALORAT,
    PAR.NOMEPARC, PAR.CODPARC
    
    FROM TGFCAB CAB
    , TGFPAR PAR
    , TGFITE ITE
    , TGFPRO PRO
    , TGFGRU GRU 
    , TGFTOP TPO
    , VGFCAB VCAB
    , TGFVEN VEN 
    WHERE (CAB.STATUSNOTA = 'L' OR :STATUSNOTA = 'N')
    AND ITE.USOPROD <> 'D'
    AND TPO.GOLSINAL= -1
    AND CAB.CODVEND= VEN.CODVEND
    AND VCAB.NUNOTA= CAB.NUNOTA
    AND PRO.CODGRUPOPROD= GRU.CODGRUPOPROD
    AND ((TPO.GRUPO IN :TOP))  
    AND CAB.CODEMP IN :EMPRESA
    AND CAB.DTNEG BETWEEN :PERIODO2.INI AND :PERIODO2.FIN AND CAB.CODEMP IN :EMPRESA
    AND ((PRO.CODPROD= :PRODUTO) OR (:PRODUTO IS NULL))
    AND ((CAB.CODPARC= :CODPARC) OR (:CODPARC IS NULL))
    AND ((CAB.CODVEND= :VENDEDOR) OR (:VENDEDOR IS NULL))
    AND ((PRO.CODGRUPOPROD= :GRUPO) OR (:GRUPO IS NULL))
    AND CAB.CODPARC = PAR.CODPARC
    AND CAB.NUNOTA = ITE.NUNOTA
    AND ITE.CODPROD = PRO.CODPROD
    AND CAB.CODTIPOPER = TPO.CODTIPOPER
    AND CAB.DHTIPOPER = TPO.DHALTER
    GROUP BY PAR.NOMEPARC, PAR.CODPARC
    ) A
    GROUP BY NOMEPARC, CODPARC
    HAVING SUM(VALORAT)< SUM(VALORANT)
    ORDER BY 1 DESC