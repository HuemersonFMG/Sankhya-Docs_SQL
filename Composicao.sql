SELECT TGFICP.SEQUENCIA AS SEQUENCIA,
            (SELECT CASE TGFITR.ATIVO WHEN 'S' THEN 'INATIVO' ELSE 'NÃO' END FROM TGFITR WHERE TGFITR.CODREGRA = 61 AND TGFITR.CODINSTPRINC = TGFICP.CODMATPRIMA) AS STATUS,
            TGFICP.CODPROD AS COMPOSICAO,Produto.DESCRPROD AS DESCCOMPOSICAO, LENGTH(Produto.DESCRPROD) AS QTCARACT,
            TGFICP.CODMATPRIMA AS CODPROD,ProdutoMateriaPrima.DESCRPROD AS DESCPROD,TGFICP.QTDMISTURA AS QTD,
            (SELECT NVL(CUSREP,0) FROM TGFCUS WHERE CODPROD=TGFICP.CODMATPRIMA AND CODEMP=1 AND DTATUAL=(SELECT MAX(DTATUAL) FROM TGFCUS WHERE CODPROD=TGFICP.CODMATPRIMA)) AS AD_CUSTO,
            TGFICP.PRECO AS PRECO,
            (SELECT REFERENCIA FROM TGFPRO WHERE CODPROD = TGFICP.CODMATPRIMA) AS EAN,
            (SELECT (PRO.PESOBRUTO) FROM TGFPRO PRO WHERE PRO.CODPROD = TGFICP.CODMATPRIMA) AS PESOUNIT,
            (SELECT (PRO.PESOBRUTO) * (TGFICP.QTDMISTURA) FROM TGFPRO PRO WHERE PRO.CODPROD = TGFICP.CODMATPRIMA) AS PESOQT,
            Volume.DESCRVOL AS DESCRVOL FROM TGFICP
            left join (SELECT DESCRLOCAL,CODLOCAL FROM TGFLOC) LocalFinanceiro  ON(TGFICP.CODLOCAL = LocalFinanceiro.CODLOCAL)
            left join (SELECT DESCRLOCAL,CODLOCAL FROM TGFLOC) LocalMateriaPrima  ON(TGFICP.CODLOCALMP = LocalMateriaPrima.CODLOCAL)
            left join (SELECT DESCRPROD,CODPROD FROM TGFPRO) Produto  ON(TGFICP.CODPROD = Produto.CODPROD)
            left join (SELECT DESCRPROD,CODPROD FROM TGFPRO) ProdutoMateriaPrima  ON(TGFICP.CODMATPRIMA = ProdutoMateriaPrima.CODPROD)
            left join (SELECT DESCRVOL,CODVOL FROM TGFVOL) Volume  ON(TGFICP.CODVOL = Volume.CODVOL)
            WHERE TGFICP.CODLOCAL = 0 AND TGFICP.CONTROLE = ' ' AND TGFICP.VARIACAO = 30000
            --AND ($P{COMP} is null or TGFICP.CODPROD in ($P!{COMP}))
            AND TGFICP.CODPROD IN (3887)
            ORDER BY COMPOSICAO, DESCPROD ASC