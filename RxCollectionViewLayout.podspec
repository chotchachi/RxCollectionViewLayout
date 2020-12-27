Pod::Spec.new do |spec|
  spec.name         = 'RxCollectionViewLayout'
  spec.version      = '0.0.2'
  spec.authors      = { 'ThanhQuang' => 'thanhquang.stahli@gmail.com' }
  spec.summary      = 'Reactive extension for CollectionViewLayout'
  spec.license      = { 
    :type => 'MIT',
    :file => 'LICENSE' 
  }
  spec.homepage     = 'https://github.com/chotchachi/RxCollectionViewLayout'
  spec.source       = { 
    :git => 'https://github.com/chotchachi/RxCollectionViewLayout.git', 
    :branch => 'main',
    :tag => '0.0.2'
  }
  spec.source_files  = "RxCollectionViewLayout/**/*.{h,m,swift}"
  spec.swift_versions = '5.0'
  spec.ios.deployment_target = '11.0'
  spec.framework    = 'SystemConfiguration'
  spec.dependency 'RxDataSources', '~> 4.0'
  spec.dependency 'RxSwift', '~> 5.1.1'
  spec.dependency 'RxCocoa', '~> 5.1.1'

end