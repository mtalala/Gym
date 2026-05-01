import Foundation

enum TipoAluno: String {
    case iniciante = "Iniciante"
    case intermediario = "Intermediário"
    case avancado = "Avançado"
}

enum Categorias: String {
    case musculacao = "Musculacao"
    case spinning = "Spinning"
    case funcional = "Funcional"
    case luta = "Luta"
    case yoga = "Yoga"
}

class Pessoa {
    let nome: String
    let email: String
    let funcao: String

    init(nome: String, email: String, funcao: String) {
        self.nome = nome
        self.email = email
        self.funcao = funcao
    }
}

struct PlanoAssinatura {
    let nome: String
    let valorMensalidade: Double
    let incluiPersonalTrainer: Bool
    let limiteAulasColetivas: Int
    let duracaoEmMeses: Int

    init(
        nome: String,
        valorMensalidade: Double,
        incluiPersonalTrainer: Bool,
        limiteAulasColetivas: Int,
        duracaoEmMeses: Int
    ) {
        self.nome = nome
        self.valorMensalidade = valorMensalidade
        self.incluiPersonalTrainer = incluiPersonalTrainer
        self.limiteAulasColetivas = limiteAulasColetivas
        self.duracaoEmMeses = duracaoEmMeses
    }

    static let mensal = PlanoAssinatura(
        nome: "Mensal",
        valorMensalidade: 120.0,
        incluiPersonalTrainer: false,
        limiteAulasColetivas: 8,
        duracaoEmMeses: 1
    )

    static let trimestral = PlanoAssinatura(
        nome: "Trimestral",
        valorMensalidade: 110.0,
        incluiPersonalTrainer: false,
        limiteAulasColetivas: 12,
        duracaoEmMeses: 3
    )

    static let anual = PlanoAssinatura(
        nome: "Anual",
        valorMensalidade: 95.0,
        incluiPersonalTrainer: true,
        limiteAulasColetivas: 20,
        duracaoEmMeses: 12
    )

    static func catalogo() -> [PlanoAssinatura] {
        [mensal, trimestral, anual]
    }
}

final class Aluno: Pessoa {

    let matricula: String
    var plano: PlanoAssinatura
    var nivel: TipoAluno

    init(
        nome: String,
        email: String,
        matricula: String,
        plano: PlanoAssinatura,
        nivel: TipoAluno
    ) {
        self.matricula = matricula
        self.plano = plano
        self.nivel = nivel
        super.init(nome: nome, email: email, funcao: "Aluno")
    }

    func atualizarPlano(plano: PlanoAssinatura) {
        self.plano = plano
    }

    func atualizarNivel(nivel: TipoAluno) {
        self.nivel = nivel
    }
}

final class Instrutor: Pessoa {

    let especialidade: Categorias

    init(nome: String, email: String, especialidade: Categorias) {
        self.especialidade = especialidade
        super.init(nome: nome, email: email, funcao: "Instrutor")
    }
}
