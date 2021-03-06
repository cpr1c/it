
&НаКлиенте
Процедура КаналПриИзменении(Элемент)
	УстановитьОрганичениеТиповНастройки();
КонецПроцедуры

&НаСервере
Процедура УстановитьОрганичениеТиповНастройки()
	Если Объект.Канал=Перечисления.КаналыОповещений.Email Тогда
		ОписаниеТипов=Новый ОписаниеТипов("СправочникСсылка.УчетныеЗаписиЭлектроннойПочты");
	ИначеЕсли Объект.Канал=Перечисления.КаналыОповещений.RocketChat Тогда
		ОписаниеТипов=Новый ОписаниеТипов("СправочникСсылка.УчетныеЗаписиRocketChat");
	Иначе
		ОписаниеТипов=Новый ОписаниеТипов;
	КонецЕсли;
	Элементы.Настройка.ОграничениеТипа=ОписаниеТипов;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьОрганичениеТиповНастройки();
КонецПроцедуры

