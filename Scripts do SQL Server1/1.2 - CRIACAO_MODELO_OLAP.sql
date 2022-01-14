CREATE DATABASE [modelo_estrela_desenv]
USE [modelo_estrela_desenv]
GO
/****** Object:  Table [dbo].[Carteira]    Script Date: 08/11/2021 15:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Carteira](
	[IdCarteira] [int] NOT NULL,
	[Nome] [varchar](145) NOT NULL,
	[Descricao] [varchar](128) NULL,
 CONSTRAINT [PK_Carteira] PRIMARY KEY CLUSTERED 
(
	[IdCarteira] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Investimento]    Script Date: 08/11/2021 15:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Investimento](
	[IdInvestimento] [int] NOT NULL,
	[IdCarteira] [int] NOT NULL,
	[Nome] [varchar](50) NULL,
	[ValorAplicado] [money] NULL,
	[DataAplicacao] [datetime] NULL,
	[Unidades] [int] NULL,
	[IdTipoInvestimento] [int] NULL,
 CONSTRAINT [PK_Investimento] PRIMARY KEY CLUSTERED 
(
	[IdInvestimento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Relatorio]    Script Date: 08/11/2021 15:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Relatorio](
	[IdRelatorio] [int] NOT NULL,
	[TipoRelatorio] [varchar](145) NOT NULL,
	[DataGeracao] [datetime] NOT NULL,
	[IdUsuario] [int] NULL,
 CONSTRAINT [PK_Relatorio] PRIMARY KEY CLUSTERED 
(
	[IdRelatorio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoInvestimento]    Script Date: 08/11/2021 15:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoInvestimento](
	[IdTipoInvestimento] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TipoInvestimento] PRIMARY KEY CLUSTERED 
(
	[IdTipoInvestimento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Transacoes]    Script Date: 08/11/2021 15:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transacoes](
	[IdTransacoes] [int] NOT NULL,
	[Descricao] [varchar](50) NOT NULL,
	[Data] [datetime] NOT NULL,
	[Pago_ou_Recebido] [tinyint] NOT NULL,
	[Valor] [money] NOT NULL,
	[Categoria] [varchar](50) NOT NULL,
	[IdCarteira] [int] NOT NULL,
	[IdFormaPagamento] [int] NULL,
	[IdUsuario] [int] NOT NULL,
 CONSTRAINT [PK_Transacoes] PRIMARY KEY CLUSTERED 
(
	[IdTransacoes] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuario]    Script Date: 08/11/2021 15:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuario](
	[IdUsuario] [int] NOT NULL,
	[Nome] [varchar](145) NOT NULL,
	[Sobrenome] [varchar](145) NOT NULL,
	[Email] [varchar](145) NOT NULL,
	[Senha] [varchar](145) NOT NULL,
	[CPF] [varchar](14) NULL,
 CONSTRAINT [PK_Usuario] PRIMARY KEY CLUSTERED 
(
	[IdUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Carteira] ADD  CONSTRAINT [DF__Carteira__Descri__4222D4EF]  DEFAULT (NULL) FOR [Descricao]
GO
ALTER TABLE [dbo].[Usuario] ADD  CONSTRAINT [DF__Usuario__CPF__4316F928]  DEFAULT (NULL) FOR [CPF]
GO
ALTER TABLE [dbo].[Investimento]  WITH CHECK ADD  CONSTRAINT [FK_Investimento_Carteira] FOREIGN KEY([IdCarteira])
REFERENCES [dbo].[Carteira] ([IdCarteira])
GO
ALTER TABLE [dbo].[Investimento] CHECK CONSTRAINT [FK_Investimento_Carteira]
GO
ALTER TABLE [dbo].[Investimento]  WITH CHECK ADD  CONSTRAINT [FK_Investimento_TipoInvestimento] FOREIGN KEY([IdTipoInvestimento])
REFERENCES [dbo].[TipoInvestimento] ([IdTipoInvestimento])
GO
ALTER TABLE [dbo].[Investimento] CHECK CONSTRAINT [FK_Investimento_TipoInvestimento]
GO
ALTER TABLE [dbo].[Relatorio]  WITH CHECK ADD  CONSTRAINT [FK_Relatorio_Usuario] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[Usuario] ([IdUsuario])
GO
ALTER TABLE [dbo].[Relatorio] CHECK CONSTRAINT [FK_Relatorio_Usuario]
GO
ALTER TABLE [dbo].[Transacoes]  WITH CHECK ADD  CONSTRAINT [FK_Transacoes_Carteira] FOREIGN KEY([IdCarteira])
REFERENCES [dbo].[Carteira] ([IdCarteira])
GO
ALTER TABLE [dbo].[Transacoes] CHECK CONSTRAINT [FK_Transacoes_Carteira]
GO
ALTER TABLE [dbo].[Transacoes]  WITH CHECK ADD  CONSTRAINT [FK_Transacoes_Usuario] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[Usuario] ([IdUsuario])
GO
ALTER TABLE [dbo].[Transacoes] CHECK CONSTRAINT [FK_Transacoes_Usuario]
GO