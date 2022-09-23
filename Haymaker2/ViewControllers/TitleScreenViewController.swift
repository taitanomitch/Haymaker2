import UIKit

class TitleScreenViewController: UIViewController {
    
    // MARK: IBOutlet Variables
    @IBOutlet weak var BeginButton: UIButton!

    
    // MARK: Loading Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        runSetup()
        let AttackCollecton = AttackCollection()
        let AttackIDToCheck: String = "Punch1"
        print(AttackCollecton.getAttackFromDictionary(AttackID: AttackIDToCheck).AttackName)
        print(AttackCollecton.getAttackFromDictionary(AttackID: AttackIDToCheck).AttackClass)
        print(AttackCollecton.getAttackFromDictionary(AttackID: AttackIDToCheck).AttackDamageDie)
        print(AttackCollecton.getAttackFromDictionary(AttackID: AttackIDToCheck).AttackBuff.BuffName)
        
        print("")
        
        let Deckmanager = DeckManager()
        print(Deckmanager.Deck[0].CardName)
        print(Deckmanager.Deck[1].CardName)
        print(Deckmanager.Deck[2].CardName)
        
        print("")
        
        let WeaponCollection = WeaponCollection()
        let WeaponDictionary = WeaponCollection.WeaponDictionary
        let TestWeapon: String = "Example1"
        print(WeaponDictionary[TestWeapon]!.PrimaryAttack.AttackName)
        print(WeaponDictionary[TestWeapon]!.PrimaryAttack.AttackDamageDie)
        print("Test gits")
    }
    
    // MARK: Setup Functions
    func runSetup() {
        setUpButtonUI()
    }
    
    func setUpButtonUI() {
        BeginButton.setTitle("Begin", for: .normal)
    }
    
    // MARK: Button Press Functions
    @IBAction func pressBeginButton(_ sender: UIButton) {
        
    }
    
}

