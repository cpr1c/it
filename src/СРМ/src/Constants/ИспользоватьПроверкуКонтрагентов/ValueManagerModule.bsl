////////////////////////////////////////////////////////////////////////////////
// Действия при изменении константы.
//  
////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	// При записи преднамеренно не используется ОбменДанными.Загрузка.
	// Причина в том, что по РИБ может перемещаться только константа
	// "Использовать сервис проверки данных по контрагенту".
	// После того, как константа попадет в узел, должно быть включено
	// регламентное задание для периодической проверки контрагентов.
	
	// Включаем/отключаем рег задание в зависимости от выбора пользователя.
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Метаданные", Метаданные.РегламентныеЗадания.ПроверкаКонтрагентов);
	
	СписокЗаданий = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыЗадания);
	
	Если СписокЗаданий.Количество() > 0 Тогда
		
		ИспользоватьСервис 	= ПроверкаКонтрагентов.ПроверкаКонтрагентовВключена();
			
		РегламентноеЗадание = СписокЗаданий[0];
		
		РегламентноеЗадание.Использование = ИспользоватьСервис;
		РегламентноеЗадание.Записать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

