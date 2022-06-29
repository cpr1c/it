// Возвращает соответствие имен "функциональных" подсистем и значения Истина.
// У "функциональной" подсистемы снят флажок "Включать в командный интерфейс".
//
Функция ИменаПодсистем() Экспорт
	
	ОтключенныеПодсистемы = Новый Соответствие;
	//ПриОпределенииОтключенныхПодсистем(ОтключенныеПодсистемы);
	
	Имена = Новый Соответствие;
	ВставитьИменаПодчиненныхПодсистем(Имена, Метаданные, ОтключенныеПодсистемы);
	
	Возврат Новый ФиксированноеСоответствие(Имена);
	
КонецФункции

Процедура ВставитьИменаПодчиненныхПодсистем(Имена, РодительскаяПодсистема, ОтключенныеПодсистемы, ИмяРодительскойПодсистемы = "")
	
	Для Каждого ТекущаяПодсистема Из РодительскаяПодсистема.Подсистемы Цикл
		
		Если ТекущаяПодсистема.ВключатьВКомандныйИнтерфейс Тогда
			Продолжить;
		КонецЕсли;
		
		ИмяТекущейПодсистемы = ИмяРодительскойПодсистемы + ТекущаяПодсистема.Имя;
		Если ОтключенныеПодсистемы.Получить(ИмяТекущейПодсистемы) = Истина Тогда
			Продолжить;
		Иначе
			Имена.Вставить(ИмяТекущейПодсистемы, Истина);
		КонецЕсли;
		
		Если ТекущаяПодсистема.Подсистемы.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ВставитьИменаПодчиненныхПодсистем(Имена, ТекущаяПодсистема, ОтключенныеПодсистемы, ИмяТекущейПодсистемы + ".");
	
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьИдентификаторЗначенияПеречисления(ЗначениеПеречисления) Экспорт
	
	МетаданныеПеречисления=ЗначениеПеречисления.Метаданные();	
	Возврат МетаданныеПеречисления.ЗначенияПеречисления.Найти(ЗначениеПеречисления).Имя;
	
КонецФункции

Функция ВерсияПлатформы() Экспорт
	
	ИнфаОСистеме=Новый СистемнаяИнформация;
	ПолнаяВерсия=ИнфаОСистеме.ВерсияПриложения;
	
	МассивВерсии=СтрРазделить(ПолнаяВерсия,".");
	
	Возврат МассивВерсии[0]+"."+МассивВерсии[1];
	
КонецФункции

Функция ПрочитатьДанныеJSON(СтрокаJSON) Экспорт
	
	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.УстановитьСтроку(СтрокаJSON);
	
	Возврат ПрочитатьJSON(ЧтениеJSON);
	
КонецФункции

Функция ЗаписатьДанныеJSON(СтруктураДанных) Экспорт
	
	ЗаписьJSON=Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON,СтруктураДанных);
	
	Возврат ЗаписьJSON.Закрыть();
	
КонецФункции

// Преобразует структуру в РасписаниеРегламентногоЗадания.
//
// Параметры:
//  СтруктураРасписания - Структура -.
// 
// Возвращаемое значение:
//  РасписаниеРегламентногоЗадания.
//
Функция СтруктураВРасписание(Знач СтруктураРасписания) Экспорт
	
	Если СтруктураРасписания = Неопределено Тогда
		Возврат Новый РасписаниеРегламентногоЗадания();
	КонецЕсли;
	СписокПолей = "ВремяЗавершения,ВремяКонца,ВремяНачала,ДатаКонца,ДатаНачала,ДеньВМесяце,ДеньНеделиВМесяце,"
		+ "ДниНедели,ИнтервалЗавершения,Месяцы,ПаузаПовтора,ПериодНедель,ПериодПовтораВТечениеДня,ПериодПовтораДней";
	Результат = Новый РасписаниеРегламентногоЗадания;
	ЗаполнитьЗначенияСвойств(Результат, СтруктураРасписания, СписокПолей);
	ДетальныеРасписанияДня = Новый Массив;
	Для каждого Расписание Из СтруктураРасписания.ДетальныеРасписанияДня Цикл
		ДетальныеРасписанияДня.Добавить(СтруктураВРасписание(Расписание));
	КонецЦикла;
	Результат.ДетальныеРасписанияДня = ДетальныеРасписанияДня;  
	Возврат Результат;
	
КонецФункции

// Создает копию экземпляра указанного объекта.
//
// Параметры:
//  Источник - Произвольный - объект, который необходимо скопировать.
//
// Возвращаемое значение:
//  Произвольный - копия объекта, переданного в параметре Источник.
//
// Примечание:
//  Функцию нельзя использовать для объектных типов (СправочникОбъект, ДокументОбъект и т.п.).
//
Функция СкопироватьРекурсивно(Источник) Экспорт
	
	Перем Приемник;
	
	ТипИсточника = ТипЗнч(Источник);
	Если ТипИсточника = Тип("Структура") Тогда
		Приемник = СкопироватьСтруктуру(Источник);
	ИначеЕсли ТипИсточника = Тип("Соответствие") Тогда
		Приемник = СкопироватьСоответствие(Источник);
	ИначеЕсли ТипИсточника = Тип("Массив") Тогда
		Приемник = СкопироватьМассив(Источник);
	ИначеЕсли ТипИсточника = Тип("СписокЗначений") Тогда
		Приемник = СкопироватьСписокЗначений(Источник);
	ИначеЕсли ТипИсточника = Тип("ТаблицаЗначений") Тогда
		Приемник = Источник.Скопировать();
	Иначе
		Приемник = Источник;
	КонецЕсли;
	
	Возврат Приемник;
	
КонецФункции

// Создает копию значения типа Структура.
//
// Параметры:
//  СтруктураИсточник - Структура - копируемая структура.
// 
// Возвращаемое значение:
//  Структура - копия исходной структуры.
//
Функция СкопироватьСтруктуру(СтруктураИсточник) Экспорт
	
	СтруктураРезультат = Новый Структура;
	
	Для Каждого КлючИЗначение Из СтруктураИсточник Цикл
		СтруктураРезультат.Вставить(КлючИЗначение.Ключ, СкопироватьРекурсивно(КлючИЗначение.Значение));
	КонецЦикла;
	
	Возврат СтруктураРезультат;
	
КонецФункции

// Создает копию значения типа Соответствие.
//
// Параметры:
//  СоответствиеИсточник - Соответствие - соответствие, копию которого необходимо получить.
// 
// Возвращаемое значение:
//  Соответствие - копия исходного соответствия.
//
Функция СкопироватьСоответствие(СоответствиеИсточник) Экспорт
	
	СоответствиеРезультат = Новый Соответствие;
	
	Для Каждого КлючИЗначение Из СоответствиеИсточник Цикл
		СоответствиеРезультат.Вставить(КлючИЗначение.Ключ, СкопироватьРекурсивно(КлючИЗначение.Значение));
	КонецЦикла;
	
	Возврат СоответствиеРезультат;

КонецФункции

// Создает копию значения типа Массив.
//
// Параметры:
//  МассивИсточник - Массив - массив, копию которого необходимо получить.
// 
// Возвращаемое значение:
//  Массив - копия исходного массива.
//
Функция СкопироватьМассив(МассивИсточник) Экспорт
	
	МассивРезультат = Новый Массив;
	
	Для Каждого Элемент Из МассивИсточник Цикл
		МассивРезультат.Добавить(СкопироватьРекурсивно(Элемент));
	КонецЦикла;
	
	Возврат МассивРезультат;
	
КонецФункции

// Создает копию значения типа СписокЗначений.
//
// Параметры:
//  СписокИсточник - СписокЗначений - список значений, копию которого необходимо получить.
// 
// Возвращаемое значение:
//  СписокЗначений - копия исходного списка значений.
//
Функция СкопироватьСписокЗначений(СписокИсточник) Экспорт
	
	СписокРезультат = Новый СписокЗначений;
	
	Для Каждого ЭлементСписка Из СписокИсточник Цикл
		СписокРезультат.Добавить(
			СкопироватьРекурсивно(ЭлементСписка.Значение), 
			ЭлементСписка.Представление, 
			ЭлементСписка.Пометка, 
			ЭлементСписка.Картинка);
	КонецЦикла;
	
	Возврат СписокРезультат;
	
КонецФункции

// Сравнивает элементы списков значений или массивов по значениям.
Функция СпискиЗначенийИдентичны(Список1, Список2) Экспорт
	
	СпискиИдентичны = Истина;
	
	Для Каждого ЭлементСписка1 Из Список1 Цикл
		Если НайтиВСписке(Список2, ЭлементСписка1) = Неопределено Тогда
			СпискиИдентичны = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если СпискиИдентичны Тогда
		Для Каждого ЭлементСписка2 Из Список2 Цикл
			Если НайтиВСписке(Список1, ЭлементСписка2) = Неопределено Тогда
				СпискиИдентичны = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат СпискиИдентичны;
	
КонецФункции

// Выполняет поиск элемента в коллекции: списке значений или массиве.
//
Функция НайтиВСписке(Список, Элемент)
	
	Перем ЭлементВСписке;
	
	Если ТипЗнч(Список) = Тип("СписокЗначений") Тогда
		Если ТипЗнч(Элемент) = Тип("ЭлементСпискаЗначений") Тогда
			ЭлементВСписке = Список.НайтиПоЗначению(Элемент.Значение);
		Иначе
			ЭлементВСписке = Список.НайтиПоЗначению(Элемент);
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(Список) = Тип("Массив") Тогда
		ЭлементВСписке = Список.Найти(Элемент);
	КонецЕсли;
	
	Возврат ЭлементВСписке;
	
КонецФункции

// Создает массив и помещает в него переданное значение.
Функция ЗначениеВМассиве(Значение) Экспорт
	
	Массив = Новый Массив;
	Массив.Добавить(Значение);
	
	Возврат Массив;
	
КонецФункции

Функция ФорматЧислоБезРазделителей(Знач Значение) Экспорт
	
	Если ТипЗнч(Значение) = Тип("Число") Тогда
		Возврат Формат(Значение, "ЧН=0; ЧГ=0");
	ИначеЕсли ТипЗнч(Значение) = Тип("Строка") Тогда
		Возврат СтрЗаменить(Значение, Символы.НПП, "");
	Иначе
		Возврат Значение;
	КонецЕсли;
	
КонецФункции

Функция ПриНачалеРаботыСистемыРасширение() Экспорт
	
	Если Истина
		И ПравоДоступа("Администрирование", Метаданные) 
		И Не РольДоступна("RA_ОсновнаяРоль")
		И ПользователиИнформационнойБазы.ПолучитьПользователей().Количество() > 0
	Тогда
		ТекущийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
		ТекущийПользователь.Роли.Добавить(Метаданные.Роли.RA_ОсновнаяРоль);
		ТекущийПользователь.Записать();
		Возврат Истина;
	КонецЕсли;
	Возврат Ложь;
	
КонецФункции
