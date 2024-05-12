--Tratamento cadastro de Email - inibindo caracteres invalidos

CREATE OR REPLACE FUNCTION         F_VALIDA_EMAIL (P_EMAIL IN VARCHAR2, P_ERRO_TELA OUT VARCHAR2)
    RETURN BOOLEAN
IS
    --
    V_EMAIL     VARCHAR2 (200);
    -- expressão para validar e-mail
    V_PATTERN   VARCHAR2 (200)
        := '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
BEGIN
    V_EMAIL := LOWER (P_EMAIL);

    IF NOT OWA_PATTERN.MATCH (V_EMAIL, V_PATTERN)
    THEN
        P_ERRO_TELA := 'Email inválido!';
        RETURN (FALSE);
    END IF;

    IF INSTR (P_EMAIL, '..') > 0
    THEN
        P_ERRO_TELA := 'Email inválido!';
        RETURN (FALSE);
    END IF;

    IF SUBSTR(TRIM(P_EMAIL),LENGTH(TRIM(P_EMAIL))) = '.'
    THEN
        P_ERRO_TELA := 'Email inválido!';
        RETURN (FALSE);
        
    END IF;

    --
    RETURN (TRUE);
--
END F_VALIDA_EMAIL;