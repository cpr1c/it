

&НаКлиенте
Процедура ОбновитьСправочники(Команда)
	ОбновитьСправочникиНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОбновитьСправочникиНаСервере()
	ОбменДаннымиСRedmine.ОбновитьСправочники();
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьЗадачи(Команда)
	ЗагрузитьЗадачиНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьЗадачиНаСервере()
	ОбменДаннымиСRedmine.ЗагрузитьЗадачи();
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьТрудозатраты(Команда)
	ЗагрузитьТрудозатратыНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьТрудозатратыНаСервере()
	ОбменДаннымиСRedmine.ЗагрузитьТрудозатраты();
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗагрузку(Команда)
	ВыполнитьЗагрузкуНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗагрузкуНаСервере()
	
	ОбменДаннымиСRedmine.ЗагрузкаИзRedmine();
	
КонецПроцедуры



