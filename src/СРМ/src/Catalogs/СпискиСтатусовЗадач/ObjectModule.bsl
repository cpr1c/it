
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СписокСтатусов = СтрСоединить(Статусы.ВыгрузитьКолонку("Статус"), ", ");
	
КонецПроцедуры
