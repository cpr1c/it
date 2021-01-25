///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция Подключены() Экспорт
	
	Если ОбсужденияСлужебный.Заблокированы() Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	// Вызов на сервере гарантирует получение корректного состояния в случае,
	// когда данные регистрации информационной базы были изменены методом 
	// СистемаВзаимодействия.УстановитьДанныеРегистрацииИнформационнойБазы.
	Возврат СистемаВзаимодействия.ИспользованиеДоступно();
	
КонецФункции

Процедура Разблокировать() Экспорт 
	
	ОбсужденияСлужебный.Разблокировать();
	
КонецПроцедуры

#КонецОбласти