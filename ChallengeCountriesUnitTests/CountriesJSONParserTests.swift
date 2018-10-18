//
//  CountriesJSONParserTests.swift
//  ChallengeCountriesUnitTests
//
//  Created by Pavel Prokofyev on 12/10/2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import XCTest
@testable import ChallengeCountries

class CountriesJSONParserTests: XCTestCase {
    
    func testPage() {
        let json =
            """
            {
            "next":"https://feorand.github.io/ChallengeCountries/page2.json",
            "countries":[
            {
            "name": "Абхазия",
            "continent": "Eurasia",
            "capital":"Сухум",
            "population" : 243564 ,
            "description_small": "Республика Абхазия - частично признанное независимое государство. Кем не признано - для тех это Автономная Республика Абхазия в составе Грузии, причем оккупированная Россией.",
            "description": "Республика Абхазия - частично признанное независимое государство. Кем не признано - для тех это Автономная Республика Абхазия в составе Грузии, причем оккупированная Россией. С VI века начало формироваться Абхазское Царство, тесно связанное с Византией. С XV века на страну стала давить и влиять мощная Османская Империя, а в XVIII веке в ситуацию вмешалась Российская Империя: для защиты от турков манифестом Александра I в 1810 году Абхазское Княжество было присоединено к Российской Империи. С преобразованием России в СССР статус Абхазии также менялся: то советская республика, то автономия в составе грузинской ССР. С распадом Советского Союза в конце XX века возобновились конфликты: грузины посчитали, что Абхазия принадлежит им, теперь независимым, а абхазы тому воспротивились и грузинов со своей территории повыгоняли.",
            "image": "http://landmarks.ru/wp-content/uploads/2015/05/abhaziya.jpg",
            "country_info": {
            "images":[],
            "flag": "https://cdn.pixabay.com/photo/2015/10/24/21/30/abkhazia-1005013_960_720.png"
            }
            },
            {
            "name": "Австралия",
            "continent": "Australia",
            "capital":"Канберра",
            "population" : 24238610 ,
            "description_small": "Австралия (от лат. Australis - южный), также известная как Австралийский Союз, - уникальная страна, поскольку она занимает целый одноименный континент. Впрочем, есть континенты и побольше, да и по площади своей территории Австралия занимает лишь шестое место среди стран мира.",
            "description": "Австралия (от лат. Australis - южный), также известная как Австралийский Союз, - уникальная страна, поскольку она занимает целый одноименный континент. Впрочем, есть континенты и побольше, да и по площади своей территории Австралия занимает лишь шестое место среди стран мира. Официально считается, что Австралия открыта голландцами в 1606 году, но колониальные державы того времени проявили мало интереса к этой земле. Более-менее ее стали осваивать британцы, да и то поначалу лишь для того, чтобы ссылать туда своих заключенных. Колониальный период был довольно непродолжительным, однако до сих пор формальным правителем Австралии является английская королева.",
            "image": "",
            "country_info": {
            "images":["http://puteshestvia.com/uploads/images/00/00/01/2013/03/10/fb8d43.jpg","http://cdn.desktopwallpapers4.me/wallpapers/world/1280x800/4/35910-sydney-1280x800-world-wallpaper.jpg"],
            "flag":"https://upload.wikimedia.org/wikipedia/el/a/ac/Flag_of_Australia_2-3.png"
            }
            }
            ]
            }
            """
        let data = Data(bytes: json.utf8)
        
        let parser = CountriesJSONParser()
        
        let result = try! parser.page(from: data)
        
        XCTAssertEqual("https://feorand.github.io/ChallengeCountries/page2.json", result.0, "wrong next page url")
        XCTAssertEqual(2, result.1.count, "wrong number of countries")
        XCTAssertEqual("Австралия", result.1[1].name, "wrong country name")
        XCTAssertEqual(2, result.1[1].photos.count, "wrong number of photos of country")
    }
}
