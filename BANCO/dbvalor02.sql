-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 17-Nov-2018 às 00:13
-- Versão do servidor: 10.1.35-MariaDB
-- versão do PHP: 7.2.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dbvalor`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `entregavalor` (IN `in_id` INT)  BEGIN

SELECT O.objetivo AS 'Objetivo que Entrega o Valor' 
FROM objetivodireto_objetivoindireto AS OI 
INNER JOIN objetivo AS O ON OI.FKObjetivoDir = o.idobjetivo WHERE OI.FKObjetivoDir = in_id
GROUP BY O.objetivo;

CALL recebevalor (in_id);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `estrutura` (IN `in_id` INT)  BEGIN
DECLARE v_hierarquia INT;
SET v_hierarquia = 1;
SET @@max_sp_recursion_depth = 10;

DROP TEMPORARY TABLE IF EXISTS tmp_estrutura;
CREATE TEMPORARY TABLE tmp_estrutura (
hierarquia INT,
idunidade INT(11), 

nomeUnidade VARCHAR(225)
)ENGINE=MyISAM DEFAULT CHARSET=latin1;

INSERT INTO tmp_estrutura (hierarquia,idunidade ,nomeUnidade )
SELECT v_hierarquia, idunidade, nomeUnidade FROM unidade WHERE idunidade = in_id;

CALL sp_estrutura(in_id, v_hierarquia);

SELECT * FROM tmp_estrutura;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `recebevalor` (IN `in_id` INT)  BEGIN

SELECT O.objetivo AS 'Objetivo que Recebe o Valor' 
FROM objetivodireto_objetivoindireto AS OI 
INNER JOIN objetivo AS O ON OI.FKObjetivoInd = o.idobjetivo WHERE OI.FKObjetivoInd = in_id
GROUP BY O.objetivo;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_estrutura` (IN `in_id` INT, IN `in_hierarquia` INT)  BEGIN
DECLARE done BOOLEAN DEFAULT FALSE;
DECLARE v_nomeUnidade VARCHAR(225);
DECLARE v_idunidade INT;

DECLARE v_hierarquia INT;

DECLARE cursor_a CURSOR FOR
SELECT idUnidade,  nomeUnidade FROM unidade WHERE FKUnidade = in_id;
 
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = TRUE;
 
OPEN cursor_a;
REPEAT FETCH cursor_a INTO  v_idunidade , v_nomeUnidade ;
 
IF NOT done THEN
INSERT INTO tmp_estrutura (
hierarquia,
idunidade, 

nomeUnidade ) VALUE (in_hierarquia+1, v_idunidade , v_nomeUnidade );
CALL sp_estrutura (v_idunidade, in_hierarquia+1);
END IF;
 
UNTIL done END REPEAT;
CLOSE cursor_a;
 
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `impacto`
--

CREATE TABLE `impacto` (
  `idimpacto` int(11) NOT NULL,
  `impacto` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `nivel`
--

CREATE TABLE `nivel` (
  `idnivel` int(11) NOT NULL,
  `nivel` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `nivel`
--

INSERT INTO `nivel` (`idnivel`, `nivel`) VALUES
(1, 'Alta Administração'),
(2, 'Unidade Organizacional'),
(3, 'Gerência'),
(4, 'Gerência Técnica'),
(5, 'Coordenação');

-- --------------------------------------------------------

--
-- Estrutura da tabela `objetivo`
--

CREATE TABLE `objetivo` (
  `idobjetivo` int(11) NOT NULL,
  `objetivo` varchar(255) NOT NULL,
  `FKTipoObjetivo` int(11) NOT NULL,
  `FKUnidade` int(11) NOT NULL,
  `FKImpacto` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `objetivo`
--

INSERT INTO `objetivo` (`idobjetivo`, `objetivo`, `FKTipoObjetivo`, `FKUnidade`, `FKImpacto`) VALUES
(1, 'Aumentar e proteger o valor da ANAC, contribuindo no alcance dos objetivos organizacionais e na melhoria dos processos de gerenciamento de riscos, controle e governança', 1, 15, NULL),
(2, 'Fiscalizar a gestão administrativa, orçamentária, contábil, patrimonial e de pessoal da ANAC', 5, 15, NULL),
(3, 'Elaborar relatório das auditorias realizadas, propondo medidas preventivas e corretivas dos desvios detectados, se for o caso, encaminhando-o ao Diretor-Presidente', 5, 15, NULL),
(4, 'Elaborar o Plano Anual de Auditoria Interna', 3, 15, NULL),
(5, 'Elaborar minuta do Plano Anual de Auditoria Interna – Minuta PAINT', 4, 118, NULL),
(6, 'Buscar a aprovação do Plano Anual de Auditoria Interna pela Diretoria Colegiada', 4, 15, NULL),
(7, 'Executar o Plano Anual de Auditoria Interna', 3, 15, NULL),
(8, 'Executar os trabalhos de auditoria interna', 4, 117, NULL),
(9, 'Comunicar o andamento da execução e dos resultados dos trabalhos aos diretores da ANAC', 4, 15, NULL),
(10, 'Prestar conta dos trabalhos realizados pela Auditoria Interna', 3, 15, NULL),
(11, 'Elaborar o Relatório de Atividade da Auditoria Interna', 4, 118, NULL),
(12, 'Comunicar à Diretoria os resultados obtidos pela Auditoria Interna', 4, 15, NULL),
(13, 'Acompanhar o cumprimento das recomendações de auditoria interna', 3, 15, NULL),
(14, 'Propor providências sobre as ações adotadas para o atendimento das recomendações da auditoria interna', 4, 117, NULL),
(15, 'Comunicar a situação das recomendações de auditoria interna à Diretoria', 4, 15, NULL),
(16, 'Buscar resultados positivos nas avaliações de órgãos de controle externo em relação aos resultados entregues pela ANAC à sociedade', 1, 15, NULL),
(17, 'Responder pela sistematização das informações requeridas pelos órgãos de controle do Poder Executivo', 5, 15, NULL),
(18, 'Prestar informações aos órgãos externos de controle', 3, 15, NULL),
(19, 'Acompanhar o atendimento das demandas dos órgãos externos de controle', 4, 118, NULL),
(20, 'Encaminhar as informações prestadas pelas unidades demandadas aos órgãos externos de controle', 4, 15, NULL),
(21, 'Acompanhar as auditorias realizadas pelos órgãos externos de controle', 3, 15, NULL),
(22, 'Viabilizar o acesso da equipe de auditoria do órgão externo de controle à ANAC', 4, 118, NULL),
(23, 'Apoiar os gestores da ANAC no relacionamento com as equipes de auditoria do TCU ou CGU', 4, 15, NULL),
(24, 'Acompanhar o atendimento das recomendações realizadas por órgãos externos de controle ', 4, 118, NULL),
(25, 'Prestar contas à sociedade e à corte de contas dos resultados obtidos pela ANAC no cumprimento de sua missão', 1, 15, NULL),
(26, 'Coordenar o processo de Prestação de Contas Anual da ANAC ao Tribunal de Contas da União', 5, 15, NULL),
(27, 'Encaminhar as peças das contas anuais da ANAC aos órgãos competentes', 3, 15, NULL),
(28, 'Acompanhar os prazos para a entrega, pelas unidades envolvidas, das peças que compõem as contas da ANAC', 4, 118, NULL),
(29, 'Dar parecer sobre o sistema de controle interno da ANAC', 4, 15, NULL),
(30, 'Divulgar as contas anuais da ANAC para a sociedade', 4, 118, NULL);

-- --------------------------------------------------------

--
-- Estrutura da tabela `objetivodireto_objetivoindireto`
--

CREATE TABLE `objetivodireto_objetivoindireto` (
  `FKObjetivoDir` int(11) NOT NULL,
  `FKObjetivoInd` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `objetivodireto_objetivoindireto`
--

INSERT INTO `objetivodireto_objetivoindireto` (`FKObjetivoDir`, `FKObjetivoInd`) VALUES
(1, 16),
(2, 1),
(3, 1),
(4, 1),
(4, 7),
(5, 4),
(6, 4),
(7, 1),
(7, 10),
(7, 13),
(8, 7),
(9, 7),
(10, 1),
(11, 10),
(12, 10),
(13, 1),
(13, 10),
(14, 13),
(15, 13),
(16, 25),
(18, 10),
(18, 16),
(19, 18),
(20, 18),
(21, 10),
(21, 16),
(21, 25),
(22, 21),
(23, 21),
(27, 25),
(28, 27),
(29, 27),
(30, 27);

-- --------------------------------------------------------

--
-- Estrutura da tabela `requisito`
--

CREATE TABLE `requisito` (
  `idrequisito` int(11) NOT NULL,
  `descRequisito` text,
  `FKtipoRequisito` int(11) NOT NULL,
  `FKObjetivo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tipoobjetivo`
--

CREATE TABLE `tipoobjetivo` (
  `idtipo` int(11) NOT NULL,
  `tipoObjetivo` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tipoobjetivo`
--

INSERT INTO `tipoobjetivo` (`idtipo`, `tipoObjetivo`) VALUES
(1, 'Estratégico'),
(2, 'Macro Objetivo'),
(3, 'Tático'),
(4, 'Operacional'),
(5, 'Regimental');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tiporequisito`
--

CREATE TABLE `tiporequisito` (
  `idtipoRequisito` int(11) NOT NULL,
  `tipoRequisito` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tiporequisito`
--

INSERT INTO `tiporequisito` (`idtipoRequisito`, `tipoRequisito`) VALUES
(1, 'Eficiência'),
(2, 'Eficácia'),
(3, 'Efetividade'),
(4, 'Informação'),
(5, 'Conformidade');

-- --------------------------------------------------------

--
-- Estrutura da tabela `unidade`
--

CREATE TABLE `unidade` (
  `idunidade` int(11) NOT NULL,
  `sigla` varchar(20) DEFAULT NULL,
  `nomeUnidade` varchar(225) DEFAULT NULL,
  `FKNivel` int(11) NOT NULL,
  `FKUnidade` int(11) DEFAULT NULL,
  `status` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `unidade`
--

INSERT INTO `unidade` (`idunidade`, `sigla`, `nomeUnidade`, `FKNivel`, `FKUnidade`, `status`) VALUES
(1, 'DIR', 'Diretoria', 1, 0, 0),
(2, 'DIR-P', 'Diretor-Presidente', 1, 1, 0),
(3, 'GAB', 'Gabinete', 2, 1, 0),
(4, 'ASPAR', 'Assessoria Parlamentar', 3, 1, 0),
(5, 'ASCOM', 'Assessoria de Comunicação Social', 3, 1, 0),
(6, 'GTRI', 'Gerência Técnica de Relações com a Imprensa', 4, 5, 0),
(7, 'GTPP', 'Gerência Técnica de Publicidade e Propaganda', 4, 5, 0),
(8, 'GTRP', 'Gerência Técnica de Relações Públicas', 4, 5, 0),
(9, 'GTCI', 'Gerência Técnica de Comunicação Integrada', 4, 5, 0),
(10, 'ASTEC', 'Assessoria Técnica', 3, 1, 0),
(11, 'GTCP', 'Gerência Técnica de Coordenação Assessoramento e Padronização de Atos', 4, 10, 0),
(12, 'OUV', 'Ouvidoria', 2, 1, 0),
(13, 'CRG', 'Corregedoria', 2, 1, 0),
(14, 'PF-ANAC', 'Procuradoria', 2, 1, 0),
(15, 'AUD', 'Auditoria Interna', 2, 1, 0),
(16, 'ASIPAER', 'Assessoria de Articulação com o Sistema de Investigação e Prevenção de Acidentes Aeronáuticos', 3, 1, 0),
(17, 'ASINT', 'Assessoria Internacional', 3, 1, 0),
(18, 'ASJIN', 'Assessoria de Julgamento de Autos em Segunda Instância', 3, 2, 0),
(19, 'SAS', 'Superintendência de Acompanhamento de Serviços Aéreos', 2, 1, 0),
(20, 'GEAM', 'Gerência de Acesso ao Mercado', 3, 19, 0),
(21, 'GTNA', 'Gerência Técnica de Negociação de Acordos de Serviços Aéreos', 4, 20, 0),
(22, 'GTOS', 'Gerência Técnica de Outorgas de Serviços Aéreos', 4, 20, 0),
(23, 'GCON', 'Gerência de Regulação das Relações de Consumo', 3, 19, 0),
(24, 'GOPE', 'Gerência de Operações de Serviços Aéreos', 3, 19, 0),
(25, 'GTMS', 'Gerência Técnica de Monitoramento de Serviços Aéreos', 4, 24, 0),
(26, 'GTCS', 'Gerência Técnica de Coordenação de Slots', 4, 24, 0),
(27, 'GEAC', 'Gerência de Acompanhamento de Mercado', 3, 19, 0),
(28, 'GTES', 'Gerência Técnica de Análise Estatística', 4, 27, 0),
(29, 'GTEC', 'Gerência Técnica de Análise Econômica', 4, 27, 0),
(30, 'GTAS', 'Gerência Técnica de Assessoramento', 4, 19, 0),
(31, 'SIA', 'Superintendência de Infraestrutura Aeroportuária', 2, 1, 0),
(32, 'GCOP', 'Gerência de Certificação e Segurança Operacional', 3, 31, 0),
(33, 'GTOP', 'Gerência Técnica de Infraestrutura e Operações Aeroportuárias', 4, 32, 0),
(34, 'GTEM', 'Gerência Técnica de Engenharia e Manutenção Aeroportuária', 4, 32, 0),
(35, 'GTRE', 'Gerência Técnica de Resposta à Emergência Aeroportuária', 4, 32, 0),
(36, 'GTDA', 'Gerência Técnica de Desenvolvimento Aeroportuário', 4, 32, 0),
(37, 'GSAC', 'Gerência de Segurança da Aviação Civil contra Atos de Interferência Ilícita', 3, 31, 0),
(38, 'GTCA', 'Gerência Técnica de Certificação AVSEC', 4, 37, 0),
(39, 'GTCQ', 'Gerência Técnica de Controle de Qualidade AVSEC', 4, 37, 0),
(40, 'GNAD', 'Gerência de Normas, Análise de Autos de Infração e Demandas Externas', 3, 31, 0),
(41, 'GTNO', 'Gerência Técnica de Normas', 4, 40, 0),
(42, 'GFIC', 'Gerência de Controle e Fiscalização', 4, 31, 0),
(43, 'GTCC', 'Gerência Técnica de Controle e Cadastro', 4, 42, 0),
(44, 'GTAS', 'Gerência Técnica de Assessoramento', 4, 31, 0),
(45, 'GTPS', 'Gerência Técnica de Processos e Sistemas', 4, 31, 0),
(46, 'SPO', 'Superintendência de Padrões Operacionais', 2, 1, 0),
(47, 'GCTA', 'Gerência de Operações de Empresas de Transporte Aéreo', 3, 46, 0),
(48, 'GTAP', 'Gerência Técnica de Artigos Perigosos', 4, 47, 0),
(49, 'GOAG', 'Gerência de Operações da Aviação Geral', 3, 46, 0),
(50, 'GTCE', 'Gerência Técnica de Certificação - GTCE', 4, 49, 0),
(51, 'GTVC', 'Gerência Técnica de Vigilância Continuada', 4, 49, 0),
(52, 'GNOS', 'Gerência de Normas Operacionais e Suporte', 3, 46, 0),
(53, 'GTNO', 'Gerência Técnica de Normas Operacionais', 4, 52, 0),
(54, 'GCEP', 'Gerência de Certificação de Pessoal', 3, 46, 0),
(55, 'GTFH', 'Gerência Técnica de Fatores Humanos', 4, 54, 0),
(56, 'GCOI', 'Gerência de Certificação de Organizações de Instrução', 3, 46, 0),
(57, 'GTOF', 'Gerência Técnica de Organizações de Formação', 4, 56, 0),
(58, 'GTAD', 'Gerência Técnica de Análise de Desempenho', 4, 46, 0),
(59, 'SAR', 'Superintendência de Aeronavegabilidade', 2, 1, 0),
(60, 'GGCP', 'Gerência-Geral de Certificação de Produto Aeronáutico', 2, 59, 0),
(61, 'GCPR', 'Gerência de Programas de Certificação', 3, 60, 0),
(62, 'GCEN', 'Gerência de Engenharia de Produto', 3, 60, 0),
(63, 'GTAI', 'Gerência Técnica de Auditoria e Inspeção - GTAI', 3, 60, 0),
(64, 'GGAC', 'Gerência-Geral de Aeronavegabilidade Continuada', 2, 59, 0),
(65, 'GAEM', 'Gerência de Engenharia de Manutenção', 3, 64, 0),
(66, 'GTAR/SP', 'Gerência Técnica de Aeronavegabilidade de São Paulo', 4, 65, 0),
(67, 'GTAR/RJ', 'Gerência Técnica de Aeronavegabilidade do Rio de Janeiro', 4, 65, 0),
(68, 'GTAR/DF', 'Gerência Técnica de Aeronavegabilidade de Brasília', 4, 65, 0),
(69, 'GCVC', 'Gerência de Coordenação de Vigilância Continuada', 3, 64, 0),
(70, 'GTRAB', 'Gerência Técnica do Registro Aeronáutico Brasileiro', 4, 59, 0),
(71, 'GTPN', 'Gerência Técnica de Processo Normativo', 4, 59, 0),
(72, 'GTGC', 'Gerência Técnica de Gestão do Conhecimento de Aeronavegabilidade', 4, 59, 0),
(73, 'GTPA', 'Gerência Técnica de Planejamento e Acompanhamento', 4, 59, 0),
(74, 'SAF', 'Superintendência de Administração e Finanças', 2, 1, 0),
(75, 'GEST', 'Gerência de Gestão Estratégica de Recursos', 3, 74, 0),
(76, 'GTPO', 'Gerência Técnica de Planejamento e Orçamento', 4, 75, 0),
(77, 'GTLC', 'Gerência Técnica de Licitações e Contratos', 4, 75, 0),
(78, 'GSIN', 'Gerência de Serviços Logísticos e de Informação', 3, 74, 0),
(79, 'GTSG', 'Gerência Técnica de Serviços Gerais', 4, 78, 0),
(80, 'GTGI', 'Gerência Técnica de Gestão da Informação', 4, 78, 0),
(81, 'GTAS', 'Gerência Técnica de Assessoramento', 4, 74, 0),
(82, 'GTAF/RJ', 'Gerência Técnica de Administração e Finanças Rio de Janeiro', 4, 74, 0),
(83, 'GTAF/SP', 'Gerência Técnica de Administração e Finanças São Paulo', 4, 74, 0),
(84, 'GTFC', 'Gerência Técnica de Finanças e Contabilidade', 4, 74, 0),
(85, 'SPI', 'Superintendência de Planejamento Institucional', 2, 1, 0),
(86, 'GAPI', 'Gerência de Articulação e Planejamento Institucional', 3, 85, 0),
(87, 'GT-ESPRO', 'Gerência Técnica de Escritório de Projetos', 4, 86, 0),
(88, 'GT-ESPROC', 'Gerência Técnica de Escritório de Processos', 4, 86, 0),
(89, 'GTAS', 'Gerência Técnica de Assessoramento', 4, 85, 0),
(90, 'GTIE', 'Gerência Técnica de Organização e Análise de Informações Estratégicas', 4, 85, 0),
(91, 'STI', 'Superintendência de Tecnologia da Informação', 2, 1, 0),
(92, 'GEIT', 'Gerência de Infraestrutura Tecnológica', 3, 91, 0),
(93, 'GESI', 'Gerência de Sistemas e Informações', 3, 91, 0),
(94, 'GTPP', 'Gerência Técnica de Planejamento e Projetos', 4, 91, 0),
(95, 'SGP', 'Superintendência de Gestão de Pessoas', 2, 1, 0),
(96, 'GAPE', 'Gerência de Administração de Pessoas', 3, 95, 0),
(97, 'GDPE', 'Gerência de Desenvolvimento de Pessoas', 3, 95, 0),
(98, 'GTCA', 'Gerência Técnica de Capacitação', 4, 97, 0),
(99, 'GTRQ', 'Gerência Técnica de Recrutamento Seleção Desempenho e Qualidade de Vida', 4, 95, 0),
(100, 'GTAS', 'Gerência Técnica de Assessoramento', 4, 95, 0),
(101, 'SRA', 'Superintendência de Regulação Econômica de Aeroportos', 2, 1, 0),
(102, 'GTAS', 'Gerência Técnica de Assessoramento', 3, 101, 0),
(103, 'GOIA', 'Gerência de Outorgas de Infraestrutura Aeroportuária', 3, 101, 0),
(104, 'GERE', 'Gerência de Regulação Econômica', 3, 101, 0),
(105, 'GTAE', 'Gerência Técnica de Análise Econômica', 4, 104, 0),
(106, 'GQES', 'Gerência de Qualidade de Serviços', 3, 101, 0),
(107, 'GIOS', 'Gerência de Investimentos e Obras', 3, 101, 0),
(108, 'GTAI', 'Gerência Técnica de Análise e Acompanhamento de Investimentos', 4, 107, 0),
(109, 'GEIC', 'Gerência de Informações e Contabilidade', 3, 101, 0),
(110, 'SFI', 'Superintendência de Ação Fiscal', 2, 1, 0),
(111, 'GEOP', 'Gerência de Operações', 3, 110, 0),
(112, 'GTREG', 'Gerência Técnica de Coordenação de Unidades Administrativas Regionais', 4, 111, 0),
(113, 'GTFI', 'Gerência Técnica de Execução da Ação Fiscal', 4, 111, 0),
(114, 'GPIN', 'Gerência de Planejamento e Inteligência', 3, 110, 0),
(115, 'GTAA', 'Gerência Técnica de Análise de Autos de Infração', 4, 114, 0),
(116, 'GTAS', 'Gerência Técnica de Assessoramento', 4, 114, 0),
(117, 'COAUD', 'Coordenadoria de Auditoria Interna', 5, 15, 0),
(118, 'COPROS', 'Coordenadoria de Planejamento, Relacionamento com Órgãos Externos de Controle e Suporte à Chefia', 5, 15, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `impacto`
--
ALTER TABLE `impacto`
  ADD PRIMARY KEY (`idimpacto`);

--
-- Indexes for table `nivel`
--
ALTER TABLE `nivel`
  ADD PRIMARY KEY (`idnivel`);

--
-- Indexes for table `objetivo`
--
ALTER TABLE `objetivo`
  ADD PRIMARY KEY (`idobjetivo`),
  ADD KEY `FKUnidade` (`FKUnidade`),
  ADD KEY `FKImpacto` (`FKImpacto`),
  ADD KEY `FKTipoObjetivo` (`FKTipoObjetivo`);

--
-- Indexes for table `objetivodireto_objetivoindireto`
--
ALTER TABLE `objetivodireto_objetivoindireto`
  ADD PRIMARY KEY (`FKObjetivoDir`,`FKObjetivoInd`),
  ADD KEY `FKObjetivoInd` (`FKObjetivoInd`);

--
-- Indexes for table `requisito`
--
ALTER TABLE `requisito`
  ADD PRIMARY KEY (`idrequisito`),
  ADD KEY `fk_requisito_tipoRequisito1` (`FKtipoRequisito`),
  ADD KEY `FKObjetivo` (`FKObjetivo`);

--
-- Indexes for table `tipoobjetivo`
--
ALTER TABLE `tipoobjetivo`
  ADD PRIMARY KEY (`idtipo`);

--
-- Indexes for table `tiporequisito`
--
ALTER TABLE `tiporequisito`
  ADD PRIMARY KEY (`idtipoRequisito`);

--
-- Indexes for table `unidade`
--
ALTER TABLE `unidade`
  ADD PRIMARY KEY (`idunidade`),
  ADD KEY `fk_unidade_nivel1` (`FKNivel`),
  ADD KEY `fk_unidade_unidade1` (`FKUnidade`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `objetivo`
--
ALTER TABLE `objetivo`
  MODIFY `idobjetivo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `requisito`
--
ALTER TABLE `requisito`
  MODIFY `idrequisito` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `unidade`
--
ALTER TABLE `unidade`
  MODIFY `idunidade` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=119;

--
-- Constraints for dumped tables
--

--
-- Limitadores para a tabela `objetivo`
--
ALTER TABLE `objetivo`
  ADD CONSTRAINT `objetivo_ibfk_1` FOREIGN KEY (`FKUnidade`) REFERENCES `unidade` (`idunidade`),
  ADD CONSTRAINT `objetivo_ibfk_2` FOREIGN KEY (`FKImpacto`) REFERENCES `impacto` (`idimpacto`),
  ADD CONSTRAINT `objetivo_ibfk_3` FOREIGN KEY (`FKTipoObjetivo`) REFERENCES `tipoobjetivo` (`idtipo`);

--
-- Limitadores para a tabela `objetivodireto_objetivoindireto`
--
ALTER TABLE `objetivodireto_objetivoindireto`
  ADD CONSTRAINT `objetivodireto_objetivoindireto_ibfk_1` FOREIGN KEY (`FKObjetivoDir`) REFERENCES `objetivo` (`idobjetivo`),
  ADD CONSTRAINT `objetivodireto_objetivoindireto_ibfk_2` FOREIGN KEY (`FKObjetivoInd`) REFERENCES `objetivo` (`idobjetivo`);

--
-- Limitadores para a tabela `requisito`
--
ALTER TABLE `requisito`
  ADD CONSTRAINT `fk_requisito_tipoRequisito1` FOREIGN KEY (`FKtipoRequisito`) REFERENCES `tiporequisito` (`idtipoRequisito`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `requisito_ibfk_1` FOREIGN KEY (`FKObjetivo`) REFERENCES `objetivo` (`idobjetivo`);

--
-- Limitadores para a tabela `unidade`
--
ALTER TABLE `unidade`
  ADD CONSTRAINT `nivelhierarquico` FOREIGN KEY (`FKNivel`) REFERENCES `nivel` (`idnivel`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
