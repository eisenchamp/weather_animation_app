import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    enum WeatherCondition {
        case sunny, night, rainy, lightning, cloudy, stormy, tornado, snowy, windy
        
        var backgroundImageName: String {
            switch self {
            case .sunny: return "sunny_background"
            case .night: return "night_background"
            case .rainy: return "rainy_background"
            case .lightning: return "lightning_background"
            case .cloudy: return "rainy_background"
            case .stormy: return "stormy_background"
            case .tornado: return "tornado_background"
            case .snowy: return "sunny_background"
            case .windy: return "sunny_background"
            }
        }
    }
    
    var currentLanguage = "en"
    var currentWeather: WeatherCondition?
    let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
    
    let weatherConditions: [(String, String, UIColor, WeatherCondition)] = [
        ("Sunny", "sun.max.fill", .systemOrange, .sunny),
        ("Night", "moon.stars.fill", .systemIndigo, .night),
        ("Rainy", "drop.fill", .systemTeal, .rainy),
        ("Lightning", "cloud.bolt.fill", .systemPurple, .lightning),
        ("Cloudy", "cloud.fill", .systemGray, .cloudy),
        ("Stormy", "cloud.bolt.fill", .systemGray2, .stormy),
        ("Tornado", "tornado", .systemBrown, .tornado),
        ("Snowy", "snow", .systemBlue, .snowy),
        ("Windy", "wind", .systemCyan, .windy)
    ]
    
    var collectionView: UICollectionView!
    
    let leftCloud = UIImageView(image: UIImage(named: "cloud_1.png"))
    let middleCloud = UIImageView(image: UIImage(named: "cloud_3.png"))
    let rightCloud = UIImageView(image: UIImage(named: "cloud_5.png"))
    let sunImageView = UIImageView(image: UIImage(named: "sun.png"))
    let moonImageView = UIImageView(image: UIImage(named: "half_moon.png"))
    let rainyClound1 = UIImageView(image: UIImage(named: "rainy_cloud_1.png"))
    let rainyClound2 = UIImageView(image: UIImage(named: "rainy_cloud_2.png"))
    var rainLayer = CAEmitterLayer()
    let snowLayer = CAEmitterLayer()
    let windLayer = CAEmitterLayer()
    let windLayer2 = CAEmitterLayer()
    let lightningLayer = CAEmitterLayer()
    let tornadoLayer = CAEmitterLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(backgroundImageView)
        setupCollectionView()
        setupWeatherElements()
        
        let randomIndex = Int(arc4random_uniform(UInt32(weatherConditions.count)))
        currentWeather = weatherConditions[randomIndex].3
        
        animateWeatherCondition()
        
        DispatchQueue.main.async {
            let initialIndexPath = IndexPath(item: randomIndex, section: 0)
            self.collectionView.scrollToItem(at: initialIndexPath, at: .centeredHorizontally, animated: false)
        }
        
        collectionView.layoutIfNeeded()
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WeatherCell.self, forCellWithReuseIdentifier: "WeatherCell")
        
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherConditions.count * 1000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        let condition = weatherConditions[indexPath.item % weatherConditions.count]
        let localizedTitle = NSLocalizedString(condition.0, tableName: "Localizable", bundle: .main, value: "", comment: "")
        cell.configure(title: localizedTitle, imageName: condition.1, color: condition.2)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCondition = weatherConditions[indexPath.item % weatherConditions.count]
        currentWeather = selectedCondition.3
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = selectedCondition.2.withAlphaComponent(0.6)
        }
        let centerIndexPath = IndexPath(item: indexPath.item, section: 0)
        collectionView.scrollToItem(at: centerIndexPath, at: .centeredHorizontally, animated: true)
        animateWeatherCondition()
    }
    
    func setupWeatherElements() {
        let cloudSize: CGFloat = 150
        
        leftCloud.frame = CGRect(x: -500, y: 300, width: 500, height: 300)
        middleCloud.frame = CGRect(x: -500, y: 100, width: 500, height: 350)
        rightCloud.frame = CGRect(x: view.bounds.width, y: 200, width: 500, height: 300)
        
        sunImageView.frame = CGRect(x: -500, y: 30, width: 500, height: 500)
        moonImageView.frame = CGRect(x: view.bounds.width, y: 150, width: cloudSize, height: cloudSize)
        rainyClound1.frame = CGRect(x: -500, y: 300, width: 500, height: 300)
        rainyClound2.frame = CGRect(x: view.bounds.width, y: 200, width: 500, height: 300)
        
        view.addSubview(leftCloud)
        view.addSubview(middleCloud)
        view.addSubview(rightCloud)
        view.addSubview(sunImageView)
        view.addSubview(moonImageView)
        view.addSubview(rainyClound1)
        view.addSubview(rainyClound2)
    }
    
    func animateWeatherCondition() {
        guard let weather = currentWeather else { return }
        
        let backgroundImageName = weather.backgroundImageName
        let newBackgroundImage = UIImage(named: backgroundImageName)
        UIView.transition(with: backgroundImageView, duration: 1.0, options: .transitionCrossDissolve, animations: {
            self.backgroundImageView.image = newBackgroundImage
        }, completion: nil)
        
        stopAllExcept(weather)
        
        switch weather {
        case .sunny:
            showSun()
        case .night:
            showMoon()
        case .rainy:
            moveRainyCloudsIn()
            startRain()
        case .lightning:
            moveRainyCloudsIn()
            startLightning()
        case .cloudy:
            moveCloudsIn()
        case .stormy:
            moveRainyCloudsIn()
            startWind()
            startLightning()
        case .tornado:
            moveRainyCloudsIn()
            startTornado()
        case .snowy:
            moveCloudsIn()
            startSnow()
        case .windy:
            moveCloudsIn()
            startWind()
        }
    }
    
    func stopAllExcept(_ weather: WeatherCondition) {
        if weather != .rainy && weather != .lightning && weather != .stormy {
            stopRain()
        }
        if weather != .snowy {
            stopSnow()
        }
        if weather != .windy && weather != .stormy {
            stopWind()
        }
        if weather != .lightning && weather != .stormy {
            stopLightning()
        }
        if weather != .tornado {
            stopTornado()
        }
        if weather != .rainy && weather != .lightning && weather != .stormy && weather != .tornado {
            moveRainyCloudsOut()
        }
        if weather != .cloudy && weather != .snowy && weather != .windy {
            moveCloudsOut()
        }
    }
    
    func moveCloudsIn(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 2.0, animations: {
            self.leftCloud.center.x = self.view.bounds.width / 2 - 80
            self.middleCloud.center.x = self.view.bounds.width / 2
            self.rightCloud.center.x = self.view.bounds.width / 2 + 80
        })
        UIView.animate(withDuration: 2.0, animations: {
            self.hideMoon()
            self.hideSun()
        })
    }
    
    func moveCloudsOut(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 2.0, animations: {
            self.leftCloud.center.x = -500
            self.middleCloud.center.x = -500
            self.rightCloud.center.x = self.view.bounds.width + 250
        }, completion: { _ in completion?() })
    }
    
    func moveRainyCloudsIn(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 2.0, animations: {
            self.rainyClound1.center.x = self.view.bounds.width / 2 - 80
            self.leftCloud.center.x = self.view.bounds.width / 2
            self.leftCloud.center.y = 260
            self.rainyClound2.center.x = self.view.bounds.width / 2 + 80
        })
        UIView.animate(withDuration: 2.0, animations: {
            self.hideMoon()
            self.hideSun()
        })
    }
    
    func moveRainyCloudsOut(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 2.0, animations: {
            self.rainyClound1.center.x = -500
            self.rainyClound2.center.x = self.view.bounds.width + 250
            self.leftCloud.center.x = -500
            self.leftCloud.center.y = 450
        }, completion: { _ in completion?() })
    }
    
    func showSun() {
        UIView.animate(withDuration: 2.0, animations: {
            self.sunImageView.center.x = self.view.bounds.width / 2 - 80
            self.sunImageView.alpha = 1.0
        })
        
        UIView.animate(withDuration: 2.0, animations: {
            self.hideMoon()
            self.moveCloudsOut()
        })
    }
    
    func hideSun(){
        UIView.animate(withDuration: 2.0, animations: {
            self.sunImageView.center.x = -500
            self.sunImageView.alpha = 0.0
        })
    }
    
    func showMoon() {
        UIView.animate(withDuration: 2.0, animations: {
            self.moonImageView.center.x = self.view.bounds.width / 2 + 80
            self.moonImageView.alpha = 1.0
        })
        
        UIView.animate(withDuration: 2.0, animations: {
            self.moveCloudsOut()
            self.hideSun()
        })
    }
    
    func hideMoon(){
        UIView.animate(withDuration: 2.0, animations: {
            self.moonImageView.center.x = self.view.bounds.width + 150
            self.moonImageView.alpha = 0.0
        })
    }
    
    func startRain() {
        configureEmitterLayer(rainLayer, imageName: "drop.fill", velocity: 500, birthRate: 100, color: .lightGray)
    }
    
    func stopRain(){
        rainLayer.removeFromSuperlayer()
    }
    
    func startLightning() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.configureLightningEmitterLayer(self.lightningLayer, imageName: "lightning.png", birthRate: 3, color: UIColor.white)
            self.view.layer.addSublayer(self.lightningLayer)
            let flashAnimation = CABasicAnimation(keyPath: "emitterCells.cell.birthRate")
            flashAnimation.fromValue = 3
            flashAnimation.toValue = 0
            flashAnimation.duration = 0.1
            flashAnimation.autoreverses = true
            flashAnimation.repeatCount = .infinity
            
            self.lightningLayer.add(flashAnimation, forKey: "flash")
        }
    }
    
    func stopLightning() {
        lightningLayer.removeFromSuperlayer()
    }
    
    func startWind() {
        configureWindEmitterLayer(windLayer, imageName: "wind.png", velocity: 300, color: UIColor.lightGray)
        view.layer.addSublayer(windLayer)
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        let startPosition = CGPoint(x: -view.bounds.width / 4, y: view.bounds.height / 2)
        let endPosition = CGPoint(x: -view.bounds.width / 4, y: view.bounds.height/2)
        let path = UIBezierPath()
        path.move(to: startPosition)
        path.addLine(to: endPosition)
        
        positionAnimation.path = path.cgPath
        positionAnimation.duration = 10.0
        positionAnimation.repeatCount = .infinity
        
        windLayer.add(positionAnimation, forKey: "sideToSide")
        
        configureWindEmitterLayerFullScreen(windLayer2, imageName: "drop.fill", velocity: 500, color: UIColor.gray)
        view.layer.addSublayer(windLayer2)
    }
    
    func stopWind() {
        windLayer.removeFromSuperlayer()
        windLayer2.removeFromSuperlayer()
    }
    
    func startSnow() {
        configureEmitterLayer(snowLayer, imageName: "snowflake", velocity: 100, birthRate: 30, color: UIColor.white)
    }
    
    func stopSnow(){
        snowLayer.removeFromSuperlayer()
    }
    
    func configureEmitterLayer(_ layer: CAEmitterLayer, imageName: String, velocity: CGFloat, birthRate: Float, color: UIColor) {
        layer.emitterPosition = CGPoint(x: view.bounds.width / 2, y: 0)
        layer.emitterSize = CGSize(width: view.bounds.width, height: 1)
        layer.emitterShape = .line
        
        let cell = CAEmitterCell()
        cell.birthRate = birthRate
        cell.lifetime = 20.0
        cell.color = color.cgColor
        cell.velocity = velocity
        cell.scale = 0.1
        cell.emissionLongitude = .pi
        if let image = UIImage(systemName: imageName) {
            let tinted = tintedImage(image: image, color: color)
            cell.contents = tinted.cgImage
        }
        cell.alphaRange = 1.0
        
        guard cell.contents != nil else {
            print("Error: Image not found or unable to load")
            return
        }
        
        layer.emitterCells = [cell]
        view.layer.addSublayer(layer)
    }
    
    func tintedImage(image: UIImage, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: image.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)
        let rect = CGRect(origin: .zero, size: image.size)
        context.clip(to: rect, mask: image.cgImage!)
        color.setFill()
        context.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func startTornado() {
        stopTornado()
        
        configureTornadoLayer(tornadoLayer, imageName: "tornado.png")
        view.layer.addSublayer(tornadoLayer)
        
        tornadoLayer.position = CGPoint(x: view.bounds.width + 50, y: view.bounds.height)
        tornadoLayer.bounds = CGRect(x: 0, y: 0, width: 50, height: 100)
        tornadoLayer.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        
        let positionAnimation = CABasicAnimation(keyPath: "position.x")
        positionAnimation.fromValue = tornadoLayer.position.x
        positionAnimation.toValue = view.bounds.width / 2
        positionAnimation.duration = 2.0
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.5
        scaleAnimation.toValue = 1.0
        scaleAnimation.duration = 2.0
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [positionAnimation, scaleAnimation]
        groupAnimation.duration = 2.0
        groupAnimation.fillMode = .forwards
        groupAnimation.isRemovedOnCompletion = false
        tornadoLayer.add(groupAnimation, forKey: "moveAndScale")
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = -CGFloat.pi / 20
        rotationAnimation.toValue = CGFloat.pi / 20
        rotationAnimation.duration = 5.0
        rotationAnimation.repeatCount = .greatestFiniteMagnitude
        rotationAnimation.autoreverses = true
        tornadoLayer.add(rotationAnimation, forKey: "rotate")
    }
    
    func stopTornado() {
        tornadoLayer.removeAllAnimations()
        tornadoLayer.removeFromSuperlayer()
    }
    
    func configureTornadoLayer(_ layer: CAEmitterLayer, imageName: String) {
        layer.emitterPosition = CGPoint(x: layer.bounds.width / 2 + 100, y: layer.bounds.height / 2 - 150)
        layer.emitterSize = CGSize(width: layer.bounds.width, height: 1)
        layer.emitterShape = .point
        
        let cell = CAEmitterCell()
        cell.birthRate = 1
        cell.lifetime = 1.0
        cell.velocity = 20
        cell.scale = 0.8
        cell.emissionLongitude = .pi
        cell.contents = UIImage(named: imageName)?.cgImage
        
        layer.emitterCells = [cell]
    }
    
    func configureLightningEmitterLayer(_ layer: CAEmitterLayer, imageName: String, birthRate: Float, color: UIColor) {
        layer.emitterPosition = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / (1.33))
        layer.emitterSize = CGSize(width: view.bounds.width, height: 1)
        layer.emitterShape = .line
        
        let cell = CAEmitterCell()
        cell.birthRate = birthRate
        cell.lifetime = 0.2
        cell.velocity = 0
        cell.scale = 1.0
        cell.emissionLongitude = .pi / 2
        cell.contents = UIImage(named: imageName)?.cgImage
        cell.color = color.cgColor
        cell.alphaSpeed = -5
        guard cell.contents != nil else {
            print("Error: Image not found or unable to load")
            return
        }
        
        layer.emitterCells = [cell]
    }
    
    func configureWindEmitterLayer(_ layer: CAEmitterLayer, imageName: String, velocity: CGFloat, color: UIColor) {
        layer.emitterPosition = CGPoint(x: 0, y: view.bounds.height / 4)
        layer.emitterSize = CGSize(width: view.bounds.width, height: 1)
        layer.emitterShape = .line
        
        let cell = CAEmitterCell()
        cell.birthRate = 3
        cell.lifetime = 10.0
        cell.velocity = velocity
        cell.velocityRange = 50
        cell.scale = 0.8
        cell.emissionLongitude = .pi / 1.5
        cell.contents = UIImage(named: imageName)?.cgImage
        cell.color = color.cgColor
        cell.alphaSpeed = -0.1
        
        guard cell.contents != nil else {
            print("Error: Image not found or unable to load")
            return
        }
        
        layer.emitterCells = [cell]
    }
    
    func configureWindEmitterLayerFullScreen(_ layer: CAEmitterLayer, imageName: String, velocity: CGFloat, color: UIColor) {
        layer.emitterPosition = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        layer.emitterSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        layer.emitterShape = .rectangle
        
        let cell = CAEmitterCell()
        cell.birthRate = 100
        cell.lifetime = 10.0
        cell.velocity = velocity
        cell.velocityRange = 50
        cell.scale = 0.05
        cell.emissionLongitude = .pi / 4
        cell.contents = UIImage(systemName: imageName)?.cgImage
        cell.color = color.cgColor
        cell.alphaSpeed = -0.1
        
        guard cell.contents != nil else {
            print("Error: Image not found or unable to load")
            return
        }
        
        layer.emitterCells = [cell]
    }
}

class WeatherCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, imageName: String, color: UIColor) {
        titleLabel.text = title
        imageView.image = UIImage(systemName: imageName)
        contentView.backgroundColor = color
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
}
