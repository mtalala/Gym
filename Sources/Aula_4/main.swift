
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

class GerenciadorAcademia {

    var alunos: [String: Aluno] = [:]
    var instrutores: [String: Instrutor] = [:]

    var aparelhos: [Aparelho] = []
    var turmasColetivas: [TurmaColetiva] = []
    var treinosPersonal: [TreinoPersonal] = []

    func cadastrarAluno(aluno: Aluno) {
        if alunos[aluno.matricula] != nil {
            print("Oops! Já existe um aluno com a matrícula \(aluno.matricula).")
            return
        }

        for alunoExistente in alunos.values {
            if alunoExistente.email == aluno.email {
                print("O e-mail \(aluno.email) já está cadastrado.")
                return
            }
        }

        alunos[aluno.matricula] = aluno
        print("Aluno \(aluno.nome) cadastrado com sucesso!")
    }

    func buscarAluno(matricula: String) -> Aluno? {
        return alunos[matricula]
    }

    func cadastrarInstrutor(instrutor: Instrutor) {
        for instrutorExistente in instrutores.values {
            if instrutorExistente.email == instrutor.email {
                print("O e-mail \(instrutor.email) já está cadastrado.")
                return
            }
        }

        instrutores[instrutor.nome] = instrutor
        print("Instrutor \(instrutor.nome) cadastrado com sucesso!")
    }

    func buscarInstrutor(nome: String) -> Instrutor? {
        return instrutores[nome]
    }

    func adicionarAparelho(aparelho: Aparelho) {
        aparelhos.append(aparelho)
        print("Aparelho \(aparelho.nomeItem) adicionado.")
    }

    func realizarManutencaoEmLote(data: String) {
        var aparelhosFalhos: [String] = []

        for aparelho in aparelhos {
            if !aparelho.estaFuncionando {
                print("Primeiro dia consertando \(aparelho.nomeItem)...")
                Thread.sleep(forTimeInterval: 1)

                print("Segundo dia consertando \(aparelho.nomeItem)...")
                Thread.sleep(forTimeInterval: 1)

                print("Terceiro dia consertando \(aparelho.nomeItem)...")
                Thread.sleep(forTimeInterval: 1)

                print("Quarto dia consertando \(aparelho.nomeItem)...")
                Thread.sleep(forTimeInterval: 1)

                let resultado = aparelho.realizarReparo(data: data, emDia: aparelho.estaEmDia())

                if resultado {
                    print("Aparelho \(aparelho.nomeItem) consertado com sucesso!")
                } else {
                    aparelhosFalhos.append(aparelho.nomeItem)
                }
            }
        }

        if aparelhosFalhos.isEmpty {
            print("Manutenção concluída. Todos os aparelhos estão em dia.")
        } else {
            print("Manutenção concluída. Aparelhos com falha: \(aparelhosFalhos.joined(separator: ", "))")
        }
    }

    func agendarTurmaColetiva(turma: TurmaColetiva) {
        turmasColetivas.append(turma)
        print("Turma \(turma.nome) agendada.")
    }

    func agendarTreinoPersonal(
        nome: String,
        instrutor: Instrutor,
        categoria: Categorias,
        descricao: String,
        matriculaAluno: String
    ) {
        guard let aluno = alunos[matriculaAluno] else {
            print("Aluno com matrícula \(matriculaAluno) não encontrado.")
            return
        }

        if !aluno.plano.incluiPersonalTrainer {
            print("O plano '\(aluno.plano.nome)' de \(aluno.nome) não inclui personal trainer.")
            return
        }

        let treino = TreinoPersonal(
            nome: nome,
            instrutor: instrutor,
            categoria: categoria,
            descricao: descricao,
            aluno: aluno
        )

        treinosPersonal.append(treino)
        print("Treino personal '\(nome)' agendado para \(aluno.nome).")
    }
    
    func inscreverAlunoNaTurma(aluno: Aluno, turmaNome: String) {
        guard let turma = turmasColetivas.first(where: { $0.nome == turmaNome }) else {
            print("Turma não encontrada na academia.")
            return
        }

        _ = turma.inscrever(aluno: aluno)
    }
}

let academia = GerenciadorAcademia()

let firmino = Instrutor(nome: "Firmino", email: "firmino@academia.com", especialidade: .musculacao)
let clarice = Instrutor(nome: "Clarice", email: "clarice@academia.com", especialidade: .yoga)

academia.cadastrarInstrutor(instrutor: firmino)
academia.cadastrarInstrutor(instrutor: clarice)

let hector = Aluno(
    nome: "Hector",
    email: "hector@email.com",
    matricula: "0001",
    plano: .mensal,
    nivel: .iniciante
)

let janice = Aluno(
    nome: "Janice",
    email: "janice@email.com",
    matricula: "0002",
    plano: .anual,
    nivel: .avancado
)

academia.cadastrarAluno(aluno: hector)
academia.cadastrarAluno(aluno: janice)

academia.cadastrarAluno(aluno: hector)

let esteira = Aparelho(nome: "Esteira")
let bicicleta = Aparelho(nome: "Bicicleta")
academia.adicionarAparelho(aparelho: esteira)
academia.adicionarAparelho(aparelho: bicicleta)

esteira.reportarDefeito()
academia.realizarManutencaoEmLote(data: "08/09/2025")

academia.agendarTreinoPersonal(
    nome: "Treino de força",
    instrutor: firmino,
    categoria: .musculacao,
    descricao: "Foco em hipertrofia",
    matriculaAluno: hector.matricula
)

academia.agendarTreinoPersonal(
    nome: "Yoga relaxante",
    instrutor: clarice,
    categoria: .yoga,
    descricao: "Alongamento e respiração",
    matriculaAluno: janice.matricula
)

if let alunoEncontrado = academia.buscarAluno(matricula: "0001") {
    print("Aluno encontrado: \(alunoEncontrado.nome), plano: \(alunoEncontrado.plano.nome)")
} else {
    print("Aluno não encontrado.")
}


extension GerenciadorAcademia {

    func metricasConsolidadas() -> (alunos: Int, instrutores: Int, aulas: Int, aparelhosDanificados: Int) {
        let totalAlunos = alunos.count
        let totalInstrutores = instrutores.count
        let totalAulas = turmasColetivas.count + treinosPersonal.count
        let aparelhosDanificados = aparelhos.filter { !$0.estaFuncionando }.count

        return (totalAlunos, totalInstrutores, totalAulas, aparelhosDanificados)
    }
    func aulasAtivas() -> Int {
        var total = 0

        for turma in turmasColetivas {
            if turma.atingiuMinimoParaAcontecer {
                total += 1
            }
        }

        total += treinosPersonal.count
        return total
    }
}

let pessoas: [Pessoa] = [
    firmino,
    clarice,
    hector,
    janice
]

for pessoa in pessoas {
    print("Identidade: \(pessoa.nome) - \(pessoa.funcao)")

    if let aluno = pessoa as? Aluno {
        print("Plano ativo: \(aluno.plano.nome)")
    }

    if let instrutor = pessoa as? Instrutor {
        print("Especialidade: \(instrutor.especialidade.rawValue)")
    }
}

let aulas: [Aula] = [
    TreinoPersonal(
        nome: "Extra Yoga",
        instrutor: clarice,
        categoria: .yoga,
        descricao: "Respiração",
        aluno: janice
    )
]

for aula in aulas {
    print(aula.nome)
}


academia.cadastrarAluno(aluno: hector)
academia.cadastrarInstrutor(instrutor: firmino)

let turmaSuperlotacao = TurmaColetiva(
    nome: "Musculação Intensa",
    instrutor: firmino,
    categoria: .musculacao,
    descricao: "Teste de superlotação",
    capacidadeMaxima: 1,
    capacidadeMinima: 1
)

academia.agendarTurmaColetiva(turma: turmaSuperlotacao)

academia.inscreverAlunoNaTurma(aluno: hector, turmaNome: "Musculação Intensa")
academia.inscreverAlunoNaTurma(aluno: janice, turmaNome: "Musculação Intensa")

academia.agendarTreinoPersonal(
    nome: "Personal Proibido",
    instrutor: firmino,
    categoria: .musculacao,
    descricao: "Teste restrição",
    matriculaAluno: hector.matricula
)

let stats = academia.metricasConsolidadas()
print(stats)

let aulasAtivas = academia.aulasAtivas()
print("Aulas ativas: \(aulasAtivas)")
