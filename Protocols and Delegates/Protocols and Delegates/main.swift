protocol AdvancedLifeSupport {
    func performCPR()
}

class EmergencyCallHandler {
    var delegate: AdvancedLifeSupport?
    
    func assessSituation() {
        print("Você pode me falar o que aconteceu ?")
    }
    
    func medicalEmergency() {
        delegate?.performCPR()
    }
}

struct Paramedic: AdvancedLifeSupport {
    
    // Primeira coisa a fazer é pegar o pager de emergência
    init(handler: EmergencyCallHandler) {
        handler.delegate = self
    }
    
    func performCPR() {
        print("O paramédico faz compressões torácicas, 30 por segundo.")
    }
}

class Doctor: AdvancedLifeSupport {
    
    // Primeira coisa a fazer é pegar o pager de emergência
    init(handler: EmergencyCallHandler) {
        handler.delegate = self
    }
    
    func performCPR() {
        print("O médico faz compressões torácicas, 30 por segundo.")
    }
    
    func useStethescope() {
        print("Ouvindo as batidas do coração")
    }
}

class Surgeon: Doctor {
    override func performCPR() {
        super.performCPR()
        print("Cantando alguma música...")
    }
    
    func useEletricDrill() {
        print("Barulho de furadeira...")
    }
}

let adriano = EmergencyCallHandler()
//let marcos = Paramedic(handler: adriano)
//let patricia = Doctor(handler: adriano)
let lysa = Surgeon(handler: adriano)

adriano.assessSituation()
adriano.medicalEmergency()

