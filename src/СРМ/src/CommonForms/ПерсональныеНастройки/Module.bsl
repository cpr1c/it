
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ЭтоВебКлиент = ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент();
	
	// БазоваяФункциональность
	ЗапрашиватьПодтверждениеПриЗавершенииПрограммы = СтандартныеПодсистемыСервер.ЗапрашиватьПодтверждениеПриЗавершенииПрограммы();
	// Конец БазоваяФункциональность
	
	// Пути к программам
	ПутьКПрограммеTeamViewer = ХранилищеОбщихНастроек.Загрузить("НастройкиПутейФайлов", "ПутьКПрограммеTeamViewer");
	Если Не ЗначениеЗаполнено(ПутьКПрограммеTeamViewer) Тогда
		ПутьКПрограммеTeamViewer = "C:\Program Files (x86)\TeamViewer\teamviewer.exe";
		ХранилищеОбщихНастроек.Сохранить("НастройкиПутейФайлов", "ПутьКПрограммеTeamViewer", ПутьКПрограммеTeamViewer);
	КонецЕсли;
		
	ПутьКПрограммеTightVNCViewer = ХранилищеОбщихНастроек.Загрузить("НастройкиПутейФайлов", "ПутьКПрограммеTightVNCViewer");
	Если Не ЗначениеЗаполнено(ПутьКПрограммеTightVNCViewer) Тогда
		ПутьКПрограммеTightVNCViewer = "C:\Program Files\TightVNC\tvnviewer.exe";
		ХранилищеОбщихНастроек.Сохранить("НастройкиПутейФайлов", "ПутьКПрограммеTightVNCViewer", ПутьКПрограммеTightVNCViewer);
	КонецЕсли;
		
		
	ПутьКПрограммеАммиАдмин = ХранилищеОбщихНастроек.Загрузить("НастройкиПутейФайлов", "ПутьКПрограммеАммиАдмин");
	Если Не ЗначениеЗаполнено(ПутьКПрограммеАммиАдмин) Тогда
		ПутьКПрограммеАммиАдмин = "";
		ХранилищеОбщихНастроек.Сохранить("НастройкиПутейФайлов", "ПутьКПрограммеАммиАдмин", ПутьКПрограммеАммиАдмин);
	КонецЕсли;
		
	ПутьКПрограммеUltraVNCViewer = ХранилищеОбщихНастроек.Загрузить("НастройкиПутейФайлов", "ПутьКПрограммеUltraVNCViewer");
	Если Не ЗначениеЗаполнено(ПутьКПрограммеUltraVNCViewer) Тогда
		ПутьКПрограммеUltraVNCViewer = "C:\Program Files\uvnc bvba\UltraVNC\vncviewer.exe";
		ХранилищеОбщихНастроек.Сохранить("НастройкиПутейФайлов", "ПутьКПрограммеUltraVNCViewer", ПутьКПрограммеUltraVNCViewer);
	КонецЕсли;
		
	ПутьКПрограммеAnyDesk = ХранилищеОбщихНастроек.Загрузить("НастройкиПутейФайлов", "ПутьКПрограммеAnyDesk");
	Если Не ЗначениеЗаполнено(ПутьКПрограммеAnyDesk) Тогда
		ПутьКПрограммеAnyDesk = "C:\Program Files (x86)\AnyDesk\AnyDesk.exe";
		ХранилищеОбщихНастроек.Сохранить("НастройкиПутейФайлов", "ПутьКПрограммеAnyDesk", ПутьКПрограммеAnyDesk);
	КонецЕсли;
		
	ПутьКПрограммеIrfanView = ХранилищеОбщихНастроек.Загрузить("НастройкиПутейФайлов", "ПутьКПрограммеIrfanView");
	Если Не ЗначениеЗаполнено(ПутьКПрограммеIrfanView) Тогда
		ПутьКПрограммеIrfanView = "C:\Program Files (x86)\IrfanView\i_view32.exe";
		ХранилищеОбщихНастроек.Сохранить("НастройкиПутейФайлов", "ПутьКПрограммеIrfanView", ПутьКПрограммеIrfanView);
	КонецЕсли;
		
	ВариантНачальногоОтображенияТочекПодключения = ХранилищеОбщихНастроек.Загрузить("ОбщиеНастройки", "ВариантНачальногоОтображенияТочекПодключения");
	Если Не ЗначениеЗаполнено(ВариантНачальногоОтображенияТочекПодключения) Тогда
		ВариантНачальногоОтображенияТочекПодключения = Перечисления.ЦПР_ВариантыНачальногоОтображенияДерева.РаскрыватьВерхнийУровень;
		ХранилищеОбщихНастроек.Сохранить("ОбщиеНастройки", "ВариантНачальногоОтображенияТочекПодключения", ВариантНачальногоОтображенияТочекПодключения);
	КонецЕсли;
		
	ПодключатьсяПоSSHЧерезPuttyВLinux = ХранилищеОбщихНастроек.Загрузить("ОбщиеНастройки", "ПодключатьсяПоSSHЧерезPuttyВLinux");
	Если Не ЗначениеЗаполнено(ВариантНачальногоОтображенияТочекПодключения) Тогда
		ВариантНачальногоОтображенияТочекПодключения = Ложь;
		ХранилищеОбщихНастроек.Сохранить("ОбщиеНастройки", "ПодключатьсяПоSSHЧерезPuttyВLinux", ВариантНачальногоОтображенияТочекПодключения);
	КонецЕсли;
	
	ВидРедактораКомментариев = РедакторКомментария.ВидРедактораКомментарияПользователя();
	ВариантСортировкиИсторииЗадачи = УправлениеЗадачами.ВариантСортировкиИсторииЗадачиПользователя();
	
	ОткрыватьФормуРаботыСЗадачамиПриЗапуске = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ОбщиеНастройкиПользователя", 
		"ОткрыватьФормуРаботыСЗадачамиПриЗапуске");

	// работа с пользователями
	ТекущийПользователь = Пользователи.АвторизованныйПользователь();	
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьОповещение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	МассивСтруктур = Новый Массив;
	
	//Пути файлов
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "НастройкиПутейФайлов");
	Элемент.Вставить("Настройка", "ПутьКПрограммеTeamViewer");
	Элемент.Вставить("Значение", ПутьКПрограммеTeamViewer);
	МассивСтруктур.Добавить(Элемент);

	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "НастройкиПутейФайлов");
	Элемент.Вставить("Настройка", "ПутьКПрограммеАммиАдмин");
	Элемент.Вставить("Значение", ПутьКПрограммеАммиАдмин);
	МассивСтруктур.Добавить(Элемент);

	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "НастройкиПутейФайлов");
	Элемент.Вставить("Настройка", "ПутьКПрограммеTightVNCViewer");
	Элемент.Вставить("Значение", ПутьКПрограммеTightVNCViewer);
	МассивСтруктур.Добавить(Элемент);

	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "НастройкиПутейФайлов");
	Элемент.Вставить("Настройка", "ПутьКПрограммеUltraVNCViewer");
	Элемент.Вставить("Значение", ПутьКПрограммеUltraVNCViewer);
	МассивСтруктур.Добавить(Элемент);

	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "НастройкиПутейФайлов");
	Элемент.Вставить("Настройка", "ПутьКПрограммеAnyDesk");
	Элемент.Вставить("Значение", ПутьКПрограммеAnyDesk);
	МассивСтруктур.Добавить(Элемент);

	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "НастройкиПутейФайлов");
	Элемент.Вставить("Настройка", "ПутьКПрограммеIrfanView");
	Элемент.Вставить("Значение", ПутьКПрограммеIrfanView);
	МассивСтруктур.Добавить(Элемент);

	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ОбщиеНастройки");
	Элемент.Вставить("Настройка", "ВариантНачальногоОтображенияТочекПодключения");
	Элемент.Вставить("Значение", ВариантНачальногоОтображенияТочекПодключения);
	МассивСтруктур.Добавить(Элемент);

	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ОбщиеНастройки");
	Элемент.Вставить("Настройка", "ПодключатьсяПоSSHЧерезPuttyВLinux");
	Элемент.Вставить("Значение", ПодключатьсяПоSSHЧерезPuttyВLinux);
	МассивСтруктур.Добавить(Элемент);

	// БазоваяФункциональность
	МассивСтруктур.Добавить(ОписаниеНастройки(
	    "ОбщиеНастройкиПользователя",
	    "ЗапрашиватьПодтверждениеПриЗавершенииПрограммы",
	    ЗапрашиватьПодтверждениеПриЗавершенииПрограммы));
	// Конец БазоваяФункциональность
	
	МассивСтруктур.Добавить(ОписаниеНастройки(
	    "ОбщиеНастройкиПользователя",
	    "ОткрыватьФормуРаботыСЗадачамиПриЗапуске",
	    ОткрыватьФормуРаботыСЗадачамиПриЗапуске));
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранитьМассив(МассивСтруктур);
	
	РедакторКомментария.УстановитьВидРедактораКомментарияПользователя(ВидРедактораКомментариев);
	УправлениеЗадачами.УстановитьВариантСортировкиИсторииЗадачиПользователя(ВариантСортировкиИсторииЗадачи);
	
	Модифицированность = Ложь;
	Закрыть();
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРасширениеРаботыСФайламиНаКлиенте(Команда)
	НачатьУстановкуРасширенияРаботыСФайлами(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура СведенияОПользователе(Команда)
	
	ПоказатьЗначение(Неопределено, ТекущийПользователь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПараметрыСистемы(Команда)
	
	ОбновитьПовторноИспользуемыеЗначения();
	ОбновитьИнтерфейс();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерсональнаяНастройкаПроксиСервера(Команда)
	
	ОткрытьФорму("ОбщаяФорма.ПараметрыПроксиСервера",
	                  Новый Структура("НастройкаПроксиНаКлиенте", Истина));
					  
КонецПроцедуры

&НаКлиенте
Процедура ПутьКПрограммеАммиАдминНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОписаниеЗавершения=Новый ОписаниеОповещения("ПутьКПрограммеАммиАдминНачалоВыбораЗавершение", ЭтотОбъект);
	
	ВыбратьФайлПрограммыНачалоВыбора(ПутьКПрограммеАммиАдмин,"Выберите имполняемый файл",ОписаниеЗавершения);	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКПрограммеАммиАдминНачалоВыбораЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если (ВыбранныеФайлы <> Неопределено) Тогда
		ПутьКПрограммеАммиАдмин=ВыбранныеФайлы[0];
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПутьКПрограммеTeamViewerНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОписаниеЗавершения=Новый ОписаниеОповещения("ПутьКПрограммеTeamViewerНачалоВыбораЗавершение", ЭтотОбъект);
	
	ВыбратьФайлПрограммыНачалоВыбора(ПутьКПрограммеTeamViewer,"Выберите имполняемый файл",ОписаниеЗавершения);	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКПрограммеTeamViewerНачалоВыбораЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если (ВыбранныеФайлы <> Неопределено) Тогда
		ПутьКПрограммеTeamViewer=ВыбранныеФайлы[0];
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПутьКПрограммеTightVNCViewerНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОписаниеЗавершения=Новый ОписаниеОповещения("ПутьКПрограммеTightVNCViewerНачалоВыбораЗавершение", ЭтотОбъект);
	
	ВыбратьФайлПрограммыНачалоВыбора(ПутьКПрограммеTightVNCViewer,"Выберите имполняемый файл",ОписаниеЗавершения);	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКПрограммеTightVNCViewerНачалоВыбораЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если (ВыбранныеФайлы <> Неопределено) Тогда
		ПутьКПрограммеTightVNCViewer=ВыбранныеФайлы[0];
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПутьКПрограммеUltraVNCViewerНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОписаниеЗавершения=Новый ОписаниеОповещения("ПутьКПрограммеUltraVNCViewerНачалоВыбораЗавершение", ЭтотОбъект);
	
	ВыбратьФайлПрограммыНачалоВыбора(ПутьКПрограммеUltraVNCViewer,"Выберите имполняемый файл",ОписаниеЗавершения);	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКПрограммеUltraVNCViewerНачалоВыбораЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если (ВыбранныеФайлы <> Неопределено) Тогда
		ПутьКПрограммеUltraVNCViewer=ВыбранныеФайлы[0];
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПутьКПрограммеAnyDeskНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОписаниеЗавершения=Новый ОписаниеОповещения("ПутьКПрограммеAnyDeskНачалоВыбораЗавершение", ЭтотОбъект);
	
	ВыбратьФайлПрограммыНачалоВыбора(ПутьКПрограммеAnyDesk,"Выберите имполняемый файл",ОписаниеЗавершения);	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКПрограммеAnyDeskНачалоВыбораЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если (ВыбранныеФайлы <> Неопределено) Тогда
		ПутьКПрограммеAnyDesk=ВыбранныеФайлы[0];
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПутьКПрограммеIrfanViewНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОписаниеЗавершения=Новый ОписаниеОповещения("ПутьКПрограммеIrfanViewНачалоВыбораЗавершение", ЭтотОбъект);
	
	ВыбратьФайлПрограммыНачалоВыбора(ПутьКПрограммеIrfanView,"Выберите имполняемый файл",ОписаниеЗавершения);	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКПрограммеIrfanViewНачалоВыбораЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если (ВыбранныеФайлы <> Неопределено) Тогда
		ПутьКПрограммеIrfanView=ВыбранныеФайлы[0];
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НастройкаРабочегоКаталога(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НастройкаРабочегоКаталогаПродолжение", ЭтотОбъект);
	ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(ОписаниеОповещения,, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаСканирования(Команда)
	
	РаботаСФайламиКлиент.ОткрытьФормуНастройкиСканирования();
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаписатьИЗакрытьОповещение(Результат, Неопределен) Экспорт
	ЗаписатьИЗакрыть(Неопределено);
КонецПроцедуры

&НаКлиенте
Функция ОписаниеНастройки(Объект, Настройка, Значение)
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", Объект);
	Элемент.Вставить("Настройка", Настройка);
	Элемент.Вставить("Значение", Значение);
	
	Возврат Элемент;
	
КонецФункции

&НаКлиенте
Функция ВыбратьФайлПрограммыНачалоВыбора(ТекЗначение,ЗаголовокДиалога,ОписаниеЗавершения)
	ДиалогВыбораФайла=Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла.ПолноеИмяФайла=ТекЗначение;
	ДиалогВыбораФайла.Фильтр="Файлы программ *.exe|*.exe";
	ДиалогВыбораФайла.Расширение="exe";
	ДиалогВыбораФайла.МножественныйВыбор=Ложь;
	ДиалогВыбораФайла.Заголовок=ЗаголовокДиалога;
	
	ДиалогВыбораФайла.Показать(ОписаниеЗавершения);
КонецФункции

&НаКлиенте
Процедура НастройкаРабочегоКаталогаПродолжение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Истина Тогда
		РаботаСФайламиКлиент.ОткрытьФормуНастройкиРабочегоКаталога();
	КонецЕсли;
КонецПроцедуры


#КонецОбласти
