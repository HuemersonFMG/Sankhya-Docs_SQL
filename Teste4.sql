<gadget >
  <prompt-parameters>
    <parameter  id="IDEXTERNO" description="IDEXTERNO:" metadata="integer" required="false" keep-last="true" keep-date="false" show-inactives="false" label="IDEXTERNO : Número Inteiro" order="0"/>
    <parameter  id="CODCONTATO" description="CODCONTATO:" metadata="integer" required="false" keep-last="true" keep-date="false" show-inactives="false" label="CODCONTATO : Número Inteiro" order="1"/>
    <parameter  id="NOMECONTATO" description="Nome (Opcional):" metadata="text" required="false" keep-last="false" keep-date="false" show-inactives="false" label="NOMECONTATO : Texto" order="2"/>
  </prompt-parameters>
  <level id="0GE" description="Principal">
    <container orientacao="V" tamanhoRelativo="100">
      <container orientacao="V" tamanhoRelativo="100">
        <grid id="grd_0GF" useNewGrid="S">
          <expression type="sql" data-source="MGEDS">
            <![CDATA[SELECT  CARGO,
		AD_IDEXTERNO,
		CODCONTATO,
        NOMECONTATO,
        CEP,
        HABPLANENTCESTAS,
        QTDENTREGACESTAS,
        ATIVO,
        AD_EMPRESA
FROM TGFCTT
WHERE ROWNUM <= 1000
AND (NOMECONTATO LIKE :NOMECONTATO OR :NOMECONTATO IS NULL)
AND (AD_IDEXTERNO > :IDEXTERNO OR :IDEXTERNO IS NULL)--6692
ORDER BY AD_IDEXTERNO DESC]]>
          </expression>
          <metadata>
            <field name="CARGO" label="CARGO" type="S" visible="true" useFooter="false"></field>
            <field name="AD_IDEXTERNO" label="AD_IDEXTERNO" type="S" visible="true" useFooter="false"></field>
            <field name="CODCONTATO" label="CODCONTATO" type="I" visible="true" useFooter="false"></field>
            <field name="NOMECONTATO" label="NOMECONTATO" type="S" visible="true" useFooter="false"></field>
            <field name="CEP" label="CEP" type="S" visible="true" useFooter="false"></field>
            <field name="HABPLANENTCESTAS" label="HABPLANENTCESTAS" type="S" visible="true" useFooter="false"></field>
            <field name="QTDENTREGACESTAS" label="QTDENTREGACESTAS" type="I" visible="true" useFooter="false"></field>
            <field name="ATIVO" label="ATIVO" type="S" visible="true" useFooter="false"></field>
            <field name="AD_EMPRESA" label="AD_EMPRESA" type="S" visible="true" useFooter="false"></field>
          </metadata>
        </grid>
      </container>
      <container orientacao="V" tamanhoRelativo="100">
        <grid id="grd_0H0" useNewGrid="S">
          <expression type="sql" data-source="MGEDS">
            <![CDATA[SELECT  CARGO,
		AD_IDEXTERNO,
		CODCONTATO,
        NOMECONTATO,
        CEP,
        HABPLANENTCESTAS,
        QTDENTREGACESTAS,
        ATIVO,
        AD_EMPRESA
FROM TGFCTT
WHERE ROWNUM <= 1000
AND (NOMECONTATO LIKE :NOMECONTATO OR :NOMECONTATO IS NULL)
AND (CODCONTATO > :CODCONTATO OR :CODCONTATO IS NULL) --3138
ORDER BY CODCONTATO DESC]]>
          </expression>
          <metadata>
            <field name="CARGO" label="CARGO" type="S" visible="true" useFooter="false"></field>
            <field name="AD_IDEXTERNO" label="AD_IDEXTERNO" type="S" visible="true" useFooter="false"></field>
            <field name="CODCONTATO" label="CODCONTATO" type="I" visible="true" useFooter="false"></field>
            <field name="NOMECONTATO" label="NOMECONTATO" type="S" visible="true" useFooter="false"></field>
            <field name="CEP" label="CEP" type="S" visible="true" useFooter="false"></field>
            <field name="HABPLANENTCESTAS" label="HABPLANENTCESTAS" type="S" visible="true" useFooter="false"></field>
            <field name="QTDENTREGACESTAS" label="QTDENTREGACESTAS" type="I" visible="true" useFooter="false"></field>
            <field name="ATIVO" label="ATIVO" type="S" visible="true" useFooter="false"></field>
            <field name="AD_EMPRESA" label="AD_EMPRESA" type="S" visible="true" useFooter="false"></field>
          </metadata>
        </grid>
      </container>
    </container>
  </level>
</gadget>