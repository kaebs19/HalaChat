//
//  OnboardingVC.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 13/04/2025.
//

import UIKit

class OnboardingVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var animitionIMageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var datilsLabel: UILabel!
    @IBOutlet weak var imageNextView: UIImageView!
    @IBOutlet weak var nextView: UIView!
    
    
    // MARK: - Properties
    private var themeObserverId: UUID?
    private var onboardingList: [Onboarding] = Onboarding.onbordings
    private var currentIndex: Int = 0     // لتتبع الشاشة الحالية
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // عرض أول شاشة onboarding
        updateOnboardingContent(index: currentIndex)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // إعداد مراقب للسمة عند ظهور العرض
        themeObserverId = setupThemeObserver { [weak self] in
            // تحديث أي عناصر خاصة عند تغيير السمة
            self?.updateCustomUIElements()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // تنظيف المراقب عند اختفاء العرض
        clearThemeObserver(id: themeObserverId)
    }
    
    deinit {
        // تأكيد إضافي على تنظيف الموارد
        clearThemeObserver(id: themeObserverId)
    }
    
    // MARK: - Actions
    @IBAction func skipButtonTapped(_ sender: Any) {
        print("تم الانتقال إلى الشاشة الرئيسية")
        goToVC(identifiers: .WelcomeVC)
    }
    
    
}


// MARK: - UI Setup

extension OnboardingVC {
    
    private func setupUI() {
        // تطبيق تنسيق أساسي
        applyTheme()
        
        // تخصيص العناصر
        updateCustomUIElements()
        
        // إعداد حركات النقر
        setupTapGestures()
        
        // تخصيص صورة Next
        setupNextButton()
    }
    
    private func updateCustomUIElements() {
        mainView.setThemeBackground(.background)
        skipButton.customize(title: .skip, titleColorSet: .C505C69, ofSize: .size_14, font: .poppins , fontStyle: .regular)
        // تخصيص تأثيرات الانتقال للصورة
        animitionIMageView.contentMode = .scaleAspectFit
        animitionIMageView.clipsToBounds = true
        
    }
    
    private func setupNextButton() {
       imageNextView.tintColor = ThemeManager.shared.color(.primary)
        // تدوير السهم ليشير إلى اليمين (التالي) بدلاً من الخلف
       // imageNextView.transform = CGAffineTransform(rotationAngle: .pi)
    }
    
    
    private func setupTapGestures() {
        nextView.isUserInteractionEnabled = true
        let nextVC = UITapGestureRecognizer(target: self, action: #selector(handleNextVC))
        nextView.addGestureRecognizer(nextVC)
    }
    
    @objc func handleNextVC() {
        // زيادة مؤشر العرض الحالي
        currentIndex += 1
        
        // التحقق من وصولنا إلى نهاية قائمة onboarding
        if currentIndex < onboardingList.count {
            updateOnboardingContent(index: currentIndex, withAnimation: true)
        } else {
            goToVC(identifiers: .WelcomeVC)
        }
    }
    
    // تحديث محتوى شاشة onboarding
    private func updateOnboardingContent(index: Int , withAnimation: Bool = false) {
        guard  index < onboardingList.count else { return }
        
        let onboarding = onboardingList[index]
        
        if withAnimation {
            // أنيميشن للصورة
            UIView.transition(with: animitionIMageView,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: {
                self.animitionIMageView.image = UIImage(named: onboarding.animationName)
            }, completion: nil)
            
            // أنيميشن للنصوص
            UIView.animate(withDuration: 0.3, animations: {
                self.titleLabel.alpha = 0
                self.datilsLabel.alpha = 0
            }, completion: { _ in
                self.titleLabel.text = onboarding.title
                self.datilsLabel.text = onboarding.description
                
                self.titleLabel.customize(text: onboarding.title,
                                          colorSet: .text,
                                          ofSize: .size_32,
                                          font: .poppins , fontStyle: .bold
                                          ,direction: .Center)
                
                self.datilsLabel.customize(text: onboarding.description,
                                           colorSet: .text, ofSize: .size_16,
                                           font: .poppins , fontStyle: .regular,
                                           direction: .Center , lines: 3)
                
                
                UIView.animate(withDuration: 0.3) {
                    self.titleLabel.alpha = 1
                    self.datilsLabel.alpha = 1
                }
            })
            
            // أنيميشن لزر التالي
            self.animateNextButton()
            
        } else {
            animitionIMageView.image = UIImage(named: onboarding.animationName)
            titleLabel.text = onboarding.title
            datilsLabel.text = onboarding.description
            
            // إظهار زر التخطي فقط إذا لم نكن في الشاشة الأخيرة
            skipButton.isHidden = (index == onboardingList.count - 1)
        }
                
    }
    
    // أنيميشن لزر التالي
    
    private func animateNextButton() {
        // تأثير نبض للزر
        UIView.animate(withDuration: 0.2, animations: {
            self.nextView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.imageNextView.transform = CGAffineTransform(rotationAngle: .pi).scaledBy(x: 1.2, y: 1.2)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.nextView.transform = .identity
                self.imageNextView.transform = CGAffineTransform(rotationAngle: .pi)
            }
        })
    }
    
}

