
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	ПроверяемЛогин=Истина;
	Для Каждого Запись Из ЭтотОбъект Цикл
		Если Запись.ТочкаПодключения.ВидПодключения.БезЛогина ТОгда	
			ПроверяемЛогин=Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Если ПроверяемЛогин Тогда
		ПроверяемыеРеквизиты.Добавить("Логин");
	КонецЕсли;
КонецПроцедуры
