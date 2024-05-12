/*
Campo que quando a nota esta pronta para ser emitida ele coloca um ‘S’.
algumas partes do codigo foram removidas pois foram feitas por terceiros.
*/

CREATE OR REPLACE PROCEDURE SANKHYA.STP_AGD_FATAUTOMATICO(P_CODEMP IN TGFCAB.CODEMP%TYPE)
AS
   vNUNOTANOVO   TGFCAB.NUNOTA%TYPE;
   vRETORNO      VARCHAR2(4000);
   vIDLOG        INTEGER;
   vMSG          VARCHAR2(4000);
   V_COUNT       INT := 0; -- CONTADOR DO LIMITE DE GERAÇÃO DE NF
   V_LIMITENF    INT := 1; -- QUANTIDADE LIMITE DE GERAÇÃO DE NF NÃO PODE SER MUITO SENÃO CAI PELA TRANSAÇÃO JAVA = 30 MINUTOS
   V_TIMESLEEP   INT := 500;
BEGIN
   -- nao roda de fim de semana
   IF TO_CHAR(SYSDATE, 'D') IN (1, 7)
   THEN
      RETURN;
   END IF;

   BEGIN
      V_COUNT := 0;
      --------------------------------------------------------------------------
      -- Monta bloco para Faturamento
      --------------------------------------------------------------------------
      FOR cFAT IN (SELECT   DISTINCT CAB.CODEMP, --1
                                     CAB.CODPARC, --2
                                     CAB.CODTIPVENDA, --3
                                     TPOUSE.SERIESEPARACAO AS SERIEFATUMENTO, --4
                                     TPOUSE.CODTIPOPERSEP AS TOPFATURAMENTO, --5
                                     CAB.NUNOTA COMPLEMENTO, --6
                                     '0' PRIORI--7
                       FROM TGFCAB CAB
                            INNER JOIN TGFTOP TPO
                            ON TPO.CODTIPOPER = CAB.CODTIPOPER
                               AND TPO.DHALTER = CAB.DHTIPOPER
                               AND NVL(TPO.NFE, 'M') <> 'C' -- RETIRA NOTA DE COMPLEMENTO
                            INNER JOIN TGFUSE TPOUSE
                            ON (TPOUSE.CODEMP = CAB.CODEMP
                                AND TPOUSE.CODTIPOPER = CAB.CODTIPOPER)
                            INNER JOIN TGFITE ITE
                            ON ITE.NUNOTA = CAB.NUNOTA
                      WHERE CAB.CODEMP = P_CODEMP
                            AND NVL(TPO.ORCAMENTO, 'N') = 'N'
                            -- campo principal de checagem para validação de geração da nota fiscal
                            AND NVL(CAB.AD_LIBERAFATURAMENTO, 'N') = 'S'
                            AND CAB.TIPMOV = 'P'
                            AND CAB.STATUSNOTA = 'L'
                            AND CAB.PENDENTE = 'S'
                            AND NOT EXISTS
                                   (SELECT 1
                                      FROM TGFVAR VAR
                                     WHERE VAR.NUNOTAORIG = CAB.NUNOTA)
                   ORDER BY 7,6)
      LOOP
         -- VERIFICA SE O PEDIDO JÁ FOI FATURADO
         IF FC_FATURADO(CFAT.COMPLEMENTO) != 0
         THEN
            CONTINUE;
         END IF;

         BEGIN
            --faco o faturamento da nota aqui 
         EXCEPTION
            WHEN OTHERS THEN
             null;
               CONTINUE;
         END;

         V_COUNT := V_COUNT + 1;


         --------------------------------------------------------------------------
         -- Verifica a existencia da nota fiscal para transmissão
         --------------------------------------------------------------------------
         IF NVL(vNUNOTANOVO, 0) > 0
         THEN
            STP_RECALCULAIMPOSTOS_WS(vNUNOTANOVO, VRETORNO);
            --------------------------------------------------------------------------
            -- CHAMA O WS PARA O ENVIO DA NF AO SEFAZ
            --------------------------------------------------------------------------
            GERARLOTENFE_WS(P_CODEMP, vNUNOTANOVO, vRETORNO);
         ELSE
            --------------------------------------------------------------------------
            -- Registra Log
            --------------------------------------------------------------------------
            IF vRETORNO LIKE '%VALTOTFINNOT%' THEN
               STP_RECALCULAIMPOSTOS_WS(CFAT.COMPLEMENTO, VRETORNO); 
            End If;
         END IF;

         IF V_COUNT > V_LIMITENF
         THEN
            EXIT;
            V_COUNT := 0;
         END IF;
      END LOOP;
   EXCEPTION
      WHEN OTHERS THEN
      null;
   END;
   
END STP_AGD_FATAUTOMATICO;