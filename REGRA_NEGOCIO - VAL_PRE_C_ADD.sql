/*
 Regra de negócio -> validar o preenchimento de um campo adicional
 >>https://ajuda.sankhya.com.br/hc/pt-br/articles/360044598014-Regras-de-Neg%C3%B3cio<<
*/

CREATE OR REPLACE PROCEDURE AD_STP_VALIDA_NAT_ITEM(
        P_NUNOTA INT,
        P_SUCESSO OUT VARCHAR,
        P_MENSAGEM OUT VARCHAR2,
        P_CODUSULIB OUT NUMBER) AS

        P_COUNT INT;

BEGIN
        SELECT COUNT(ITE.CODPROD) INTO P_COUNT
        FROM TGFITE ITE
        WHERE ITE.NUNOTA = P_NUNOTA
        AND ITE.AD_CODNAT IS NULL;

        IF P_COUNT > 1 THEN
                 P_SUCESSO := 'N';
                 P_MENSAGEM := '<b>Não está preenchido a natureza para ' || P_COUNT || ' itens, por favor verificar.</b>';
                 P_CODUSULIB := 0;
        ELSE
                 P_SUCESSO := 'S';
        END IF;
END;