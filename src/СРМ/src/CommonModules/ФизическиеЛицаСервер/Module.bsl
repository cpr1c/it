// Функция - Контакты по email
//
// Параметры:
//  АдресЭлектроннойПочты	 - Адрес электронной почты или список адресов электронной почты для поиска физических лиц 	 - 
// 
// Возвращаемое значение:
//   -  ТаблицаЗначений
//
Функция КонтактыПоEmail(АдресЭлектроннойПочты) Экспорт
	Запрос=Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ФизическиеЛицаКонтактнаяИнформация.Ссылка КАК Контакт,
	|	ФизическиеЛицаКонтактнаяИнформация.Представление КАК Представление,
	|	ФизическиеЛицаКонтактнаяИнформация.Ссылка.Наименование КАК Наименование
	|ИЗ
	|	Справочник.ФизическиеЛица.КонтактнаяИнформация КАК ФизическиеЛицаКонтактнаяИнформация
	|ГДЕ
	|	ФизическиеЛицаКонтактнаяИнформация.АдресЭП В (&Адрес)
	|	И НЕ ФизическиеЛицаКонтактнаяИнформация.Ссылка.ПометкаУдаления
	|	И ФизическиеЛицаКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)";
	Запрос.УстановитьПараметр("Адрес",АдресЭлектроннойПочты);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция ФизическоеЛицоПоНомеруТелефона(НомерТелефона) Экспорт
	
	// номер может быть записан как +7, так и 8
	// поэтому первый символ при поиске не учитываем
	// в эту функцию передаем только числа
	
	ПустаяСсылка = Справочники.ФизическиеЛица.ПустаяСсылка();
	
	Если Не ЗначениеЗаполнено(НомерТелефона) Тогда
		Возврат ПустаяСсылка;
	КонецЕсли;
	
	Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(НомерТелефона) Тогда
		Возврат ПустаяСсылка;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КИ.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ФизическиеЛица.КонтактнаяИнформация КАК КИ
	|ГДЕ
	|	КИ.НомерТелефона ПОДОБНО &КонецНомера";
	Запрос.УстановитьПараметр("КонецНомера", "%"+Сред(НомерТелефона, 2)); 
	
	Результат = Запрос.Выполнить();

	Если Результат.Пустой() Тогда
		Возврат ПустаяСсылка;
	КонецЕсли;
	
	Таб = Результат.Выгрузить();
	Если Таб.Количество() = 1 Тогда
		Возврат Таб[0].Ссылка;
	КонецЕсли;
	
	// тут в будущем может быть уточняющие отборы
	
	Возврат ПустаяСсылка;
	
КонецФункции

Функция ПартнерыФизическогоЛица(ФизЛицо) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	ПартнерыФизическихЛиц.Партнер,
	|	ПартнерыФизическихЛиц.ФизическоеЛицо
	|ИЗ
	|	РегистрСведений.ПартнерыФизическихЛиц КАК ПартнерыФизическихЛиц
	|ГДЕ
	|	ПартнерыФизическихЛиц.ФизическоеЛицо = &ФизическоеЛицо";
	Запрос.УстановитьПараметр("ФизическоеЛицо", ФизЛицо);
	
	МассивПартнеров=Новый Массив;
	
	Выборка=Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МассивПартнеров.Добавить(Выборка.Партнер);
	КонецЦикла;
	
	Возврат МассивПартнеров;
КонецФункции

Процедура УдалитьСвязанногоПартнераФизЛица(ФизЛицо, Партнер) Экспорт
	МенеджерЗаписи=РегистрыСведений.ПартнерыФизическихЛиц.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ФизическоеЛицо=ФизЛицо;
	МенеджерЗаписи.Партнер=Партнер;
	МенеджерЗаписи.Прочитать();
	Если МенеджерЗаписи.Выбран() Тогда
		МенеджерЗаписи.Удалить();
	КонецЕсли;
КонецПроцедуры

Процедура ДобавитьСвязанногоПартнераКФизЛицу(ФизЛицо, Партнер) Экспорт
	Менеджер=РегистрыСведений.ПартнерыФизическихЛиц.СоздатьМенеджерЗаписи();
	Менеджер.ФизическоеЛицо=ФизЛицо;
	Менеджер.Партнер=Партнер;
	Менеджер.Записать(Истина);
КонецПроцедуры


