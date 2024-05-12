(Contato.AD_MENTRAGA <> '4' OR Contato.AD_MENTRAGA IS NULL)
OR
(Contato.AD_MENTRAGA = '4' AND ctx[usuario_logado] = '3')
OR
(Contato.AD_MENTRAGA = '4' AND ctx[usuario_logado] = '0')
OR
(Contato.AD_MENTRAGA = '4' AND ctx[usuario_logado] = '4')
OR
(Contato.AD_MENTRAGA = '4' AND ctx[usuario_logado] = '14')
OR
(Contato.AD_MENTRAGA = '4' AND ctx[usuario_logado] = '59' 
    AND Contato.CODPARC IN ('24184','110102','128001'))
OR
(Contato.AD_MENTRAGA = '4' AND ctx[usuario_logado] = '60'
    AND Contato.CODPARC IN ('24184','110102','128001'))