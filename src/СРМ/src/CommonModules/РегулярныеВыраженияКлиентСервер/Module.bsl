//Модуль реализован с помощью компоненты https://github.com/alexkmbk/RegEx1CAddin

//Метод НайтиСовпадения / Matches(<Текст для анализа>, <Регулярное выражение>).
//Метод выполняет поиск в переданном тексте по переданному регулярному выражению.
//Результатом выполнения метода будет массив результатов поиска. Каждый элемент массива - найденная подгруппа поиска. 
//Если подгрупп нет, то массив будет содержать один элемент - найденную строку.
//Возвращаемое значение: Ничего не возвращает.
//Для того, чтобы получить результаты выполнения метода (массив результатов), необходимо выполнить метод Следующий/Next(), 
//и после этого, в свойстве ТекущееЗначение/CurrentValue будет доступно значение текущей подгруппы результата выполнения 
//(текущий элемент массива результатов). Идея похожа на обход результата запроса.
//Пример:
//Рег.НайтиСовпадения("Hello world", "([A-Za-z]+)\s+([a-z]+)");
//Пока Рег.Следующий() Цикл Сообщить(Рег.ТекущееЗначение);
//КонецЦикла; Результат будет содержать 3 элемента:
//Hello world
//Hello
//world
//
//
//Метод Количество()/Count()
//Возвращает количество результатов поиска, после выполнения метода НайтиСовпадения / Matches
//
//Метод Заменить/Replace(<Текст для анализа>, <Регулярное выражение>, <Значение для замены>)
//Заменяет в переданном тексте часть, соответствующую регулярному выражению, значением, переданным третьим параметром.
//Возвращаемое значение: Строка, результат замены.
//
//
//Метод Совпадает/IsMatch(<Текст для анализа>, <Регулярное выражение>)
//Делает проверку на соответствие текста регулярному выражению.
//Возвращаемое значение: Булево. Возвращает значение Истина если текст соответствует регулярному выражению.
//
//Метод Версия/Version()
//Возвращает номер версии компоненты в виде строки.
//Возвращаемое значение: Строка
//
//Свойство ВсеСовпадения/Global
//Тип: Булево.
//Значение по умолчанию: Ложь.
//Если установлено в Истина, то поиск будет выполняться по всем совпадениям, а не только по первому.
//
//Свойство ИгнорироватьРегистр/IgnoreCase
//Тип: Булево.
//Значение по умолчанию: Ложь.
//Если установлено в Истина, то поиск будет осуществляться без учета регистра.
//
//Свойство Шаблон/Template
//Тип: Строка.
//Значение по умолчанию: пустая строка.
//Задает регулярное выражение которое будет использоваться при вызове методов компоненты, если в метод не передано значение регулярного выражения.
//
//Свойство ОписаниеОшибки/ErrorDescription
//Тип: Строка.
//Значение по умолчанию: пустая строка.
//Содержит текст последней ошибки. Если ошибки не было, то пустая строка.
//
//Свойство ВызыватьИсключения/ThrowExceptions
//Тип: Булево.
//Значение по умолчанию: Ложь.
//Если установлена в Истина, то при возникновении ошибки, будет вызываться исключение, при обработке исключения, текст ошибки можно получить из свойства ErrorDescription\ОписаниеОшибки.

Функция ПроинициализироватьКомпоненту(ПопытатьсяУстановитьКомпоненту = Истина) Экспорт
	
	#Если ВебКлиент Тогда
		ИмяМакетаКомпоненты="ОбщийМакет.КомпонентаРаботыСРегулярнымиВыражениямиRegExБраузеры";
	#Иначе
		ИмяМакетаКомпоненты="ОбщийМакет.КомпонентаРаботыСРегулярнымиВыражениямиRegEx";
	#КонецЕсли
	КодВозврата = ПодключитьВнешнююКомпоненту(ИмяМакетаКомпоненты, "RegEx",ТипВнешнейКомпоненты.Native);
	
	#Если Клиент Тогда
	Если Не КодВозврата Тогда
		
		Если Не ПопытатьсяУстановитьКомпоненту Тогда
			Возврат Ложь;
		КонецЕсли;
		
		УстановитьВнешнююКомпоненту(ИмяМакетаКомпоненты);
		
		Возврат ПроинициализироватьКомпоненту(Ложь); // Рекурсивно.
		
	КонецЕсли;
	#КонецЕсли
	
	Возврат Новый("AddIn.RegEx.RegEx");
КонецФункции

// Функция - Компонента регулярных выражений
//
// Параметры:
//  ВсеСовпадения		 - Булево - Если установлено в Истина, то поиск будет выполняться по всем совпадениям, а не только по первому.
//  ИгнорироватьРегистр	 - Булево - Если установлено в Истина, то поиск будет осуществляться без учета регистра
//  Шаблон				 - Строка - Задает регулярное выражение которое будет использоваться при вызове методов компоненты, 
//									если в метод не передано значение регулярного выражения
//  ВызыватьИсключения	 - Булево - Если установлена в Истина, то при возникновении ошибки, будет вызываться исключение, 
//									при обработке исключения, текст ошибки можно получить из метода ErrorDescription\ОписаниеОшибки
// 
// Возвращаемое значение:
//  ОбъектКомпоненты -"AddIn.RegEx.RegEx". 
//	Неопределено-При неудачной инициализации компоненты 
//
Функция КомпонентаРегулярныхВыражений(ВсеСовпадения=Ложь,ИгнорироватьРегистр=Ложь,Шаблон="",ВызыватьИсключения=Ложь) Экспорт
	Попытка 
		Компонента= ПроинициализироватьКомпоненту(Истина);
		Компонента.ВсеСовпадения=ВсеСовпадения;
		Компонента.ИгнорироватьРегистр=ИгнорироватьРегистр;
		Компонента.Шаблон=Шаблон;
		Компонента.ВызыватьИсключения=ВызыватьИсключения;
		
		Возврат Компонента;
	Исключение
		ТекстОшибки = НСтр("ru = 'Не удалось подключить внешнюю компоненту для работы с регулярными выражениями. Подробности в журнале регистрации.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки+ОписаниеОшибки());
		Возврат Неопределено;
	КонецПопытки;
КонецФункции

//Метод выполняет поиск в переданном тексте по переданному регулярному выражению.
//Результатом выполнения метода будет массив результатов поиска. Каждый элемент массива - найденная подгруппа поиска. 
//Если подгрупп нет, то массив будет содержать один элемент - найденную строку.
//Возвращаемое значение: Ничего не возвращает.
//Для того, чтобы получить результаты выполнения метода (массив результатов), необходимо выполнить метод Следующий/Next(), 
//и после этого, в свойстве ТекущееЗначение/CurrentValue будет доступно значение текущей подгруппы результата выполнения 
//(текущий элемент массива результатов). Идея похожа на обход результата запроса.
Функция НайтиСовпадения(СтрокаДляАнализа,РегулярноеВыражение,КомпонентаРегулярныхВыражений=Неопределено) Экспорт
	Если КомпонентаРегулярныхВыражений=Неопределено Тогда
		КомпонентаРегулярныхВыражений=КомпонентаРегулярныхВыражений();
	КонецЕсли;
	
	Если КомпонентаРегулярныхВыражений=Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	МассивСопадений=Новый Массив;
	
	КомпонентаРегулярныхВыражений.НайтиСовпадения(СтрокаДляАнализа, РегулярноеВыражение);
	
	Пока КомпонентаРегулярныхВыражений.Следующий() Цикл 
		МассивСопадений.Добавить(КомпонентаРегулярныхВыражений.ТекущееЗначение);
	КонецЦикла;
	
	Возврат МассивСопадений;
КонецФункции

//Возвращает количество результатов поиска, после выполнения метода НайтиСовпадения / Matches
Функция КоличествоСовпадений(КомпонентаРегулярныхВыражений) Экспорт
	Возврат КомпонентаРегулярныхВыражений.Количество();	
КонецФункции

//Метод Заменить/Replace(<Текст для анализа>, <Регулярное выражение>, <Значение для замены>)
//Заменяет в переданном тексте часть, соответствующую регулярному выражению, значением, переданным третьим параметром.
//Возвращаемое значение: Строка, результат замены.
Функция Заменить(ТекстДляАнализа,РегулярноеВыражение,ЗначениеДляЗамены,КомпонентаРегулярныхВыражений=Неопределено) Экспорт
	Если КомпонентаРегулярныхВыражений=Неопределено Тогда
		КомпонентаРегулярныхВыражений=КомпонентаРегулярныхВыражений();
	КонецЕсли;
	
	Если КомпонентаРегулярныхВыражений=Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат КомпонентаРегулярныхВыражений.Заменить(ТекстДляАнализа,РегулярноеВыражение,ЗначениеДляЗамены);
КонецФункции

//Метод Совпадает/IsMatch(<Текст для анализа>, <Регулярное выражение>)
//Делает проверку на соответствие текста регулярному выражению.
//Возвращаемое значение: Булево. Возвращает значение Истина если текст соответствует регулярному выражению.
Функция Совпадает(ТекстДляАнализа, РегулярноеВыражение,КомпонентаРегулярныхВыражений=Неопределено) Экспорт
	Если КомпонентаРегулярныхВыражений=Неопределено Тогда
		КомпонентаРегулярныхВыражений=КомпонентаРегулярныхВыражений();
	КонецЕсли;
	
	Если КомпонентаРегулярныхВыражений=Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат КомпонентаРегулярныхВыражений.Совпадает(ТекстДляАнализа,РегулярноеВыражение);
КонецФункции

//Метод Версия/Version()
//Возвращает номер версии компоненты в виде строки.
//Возвращаемое значение: Строка
Функция ВерсияКомпоненты(КомпонентаРегулярныхВыражений) Экспорт
	Возврат КомпонентаРегулярныхВыражений.Версия();	
КонецФункции

Функция ОписаниеОшибкиКомпоненты(КомпонентаРегулярныхВыражений) Экспорт
	Возврат КомпонентаРегулярныхВыражений.ОписаниеОшибки;
КонецФункции