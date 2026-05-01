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

protocol Manutencao {
    var nomeItem: String { get }
    var historicoManutencao: [String] { get }

    func realizarReparo(data: String, emDia: Bool) -> Bool
    func estaEmDia() -> Bool
}

class Aparelho: Manutencao {
    let nomeItem: String
    private let id: Int
    private(set) var historicoManutencao: [String] = []
    private(set) var estaFuncionando: Bool = true

    init(nome: String) {
        self.id = Int.random(in: 1000...9999)
        self.nomeItem = nome
    }

    func realizarReparo(data: String, emDia: Bool) -> Bool {
        guard !estaFuncionando else {
            print("O aparelho \(nomeItem) está funcionando, sem necessidade de reparo.")
            return false
        }
        historicoManutencao.append(data)
        estaFuncionando = true
        print("Reparo realizado no aparelho \(nomeItem) em \(data).")
        return true
    }

    func estaEmDia() -> Bool {
        return !historicoManutencao.isEmpty
    }
    
    func reportarDefeito() {
        estaFuncionando = false
        print("Quebrou!")
    }
    
    func reparar(data: String) {
        estaFuncionando = true
        print("Reparada! Funcionando...")
    }
}

protocol Aula {
    var nome: String { get }
    var instrutor: Instrutor { get }
    var categoria: Categorias { get }
    var descricao: String { get }
}

final class TurmaColetiva: Aula {
    let nome: String
    let instrutor: Instrutor
    let categoria: Categorias
    let descricao: String
    let capacidadeMaxima: Int
    let capacidadeMinima: Int
    private(set) var alunos: [Aluno] = []

    init(
        nome: String,
        instrutor: Instrutor,
        categoria: Categorias,
        descricao: String,
        capacidadeMaxima: Int,
        capacidadeMinima: Int
    ) {
        self.nome = nome
        self.instrutor = instrutor
        self.categoria = categoria
        self.descricao = descricao
        self.capacidadeMaxima = capacidadeMaxima
        self.capacidadeMinima = capacidadeMinima
    }

    func inscrever(aluno: Aluno) -> Bool {
        guard alunos.count < capacidadeMaxima else {
            print("Turma \(nome) está com capacidade máxima atingida.")
            return false
        }
        guard !alunos.contains(where: { $0.matricula == aluno.matricula }) else {
            print("Aluno \(aluno.nome) já está inscrito na turma \(nome).")
            return false
        }
        alunos.append(aluno)
        print("Aluno \(aluno.nome) inscrito na turma \(nome) com sucesso.")
        return true
    }

    var vagasDisponiveis: Int {
        capacidadeMaxima - alunos.count
    }

    var atingiuMinimoParaAcontecer: Bool {
        alunos.count >= capacidadeMinima
    }
}

final class TreinoPersonal: Aula {
    let nome: String
    let instrutor: Instrutor
    let categoria: Categorias
    let descricao: String
    let aluno: Aluno

    init(
        nome: String,
        instrutor: Instrutor,
        categoria: Categorias,
        descricao: String,
        aluno: Aluno
    ) {
        self.nome = nome
        self.instrutor = instrutor
        self.categoria = categoria
        self.descricao = descricao
        self.aluno = aluno
    }
}
