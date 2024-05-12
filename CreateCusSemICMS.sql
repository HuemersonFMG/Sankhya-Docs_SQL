CREATE OR REPLACE FUNCTION JIVA.AD_OBTEMCUSTO_MEDSEMICM(
P_CODPROD IN NUMBER,
P_CODEMP IN NUMBER,
P_DATA IN DATE)
RETURN FLOAT
IS P_CUSSEMICM FLOAT;
P_DTATUAL DATE;
BEGIN
BEGIN
SELECT
MAX(DTATUAL) INTO P_DTATUAL
FROM TGFCUS CN
WHERE CN.CODPROD = P_CODPROD
AND CN.DTATUAL <= P_DATA
AND CN.CONTROLE = ’ ’
AND CN.CODLOCAL = 0
AND CN.CODEMP = P_CODEMP;

SELECT NVL(CUSSEMICM,0)
  INTO P_CUSSEMICM
  FROM TGFCUS
 WHERE CODPROD = P_CODPROD
   AND CONTROLE = ' '
   AND CODLOCAL = 0
   AND CODEMP = P_CODEMP
   AND DTATUAL = P_DTATUAL;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RETURN 0;
WHEN OTHERS THEN
RAISE_APPLICATION_ERROR(-20101, ’ O parametro EXIBRENTNOTACAC (Exibe rentabilidade na CAC) esta ligado! ERRO: ’ || SUBSTR(SQLERRM,1,200));
END;

RETURN P_CUSSEMICM;

EXCEPTION
WHEN NO_DATA_FOUND THEN RETURN (0);
END;