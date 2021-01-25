
#Область ПрограммныйИнтерфейс

Процедура ОбновитьСправочникПроектов(МассивПроектов) Экспорт
	
	Для Каждого ПроектРедмайна ИЗ МассивПроектов Цикл
		НайтиСоздатьПроект(ПроектРедмайна);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьСправочникСтатусовЗадач(МассивСтатусовЗадач) Экспорт
	
	Для Каждого СтатусРедмайна ИЗ МассивСтатусовЗадач Цикл
		НайтиСоздатьСтатусЗадачи(СтатусРедмайна);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьСправочникПользователей(МассивПользователей) Экспорт
	
	Для Каждого ПользовательРедмайна ИЗ МассивПользователей Цикл
		НайтиСоздатьПользователя(ПользовательРедмайна);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьСправочникВерсий(МассивВерсий) Экспорт
	
	Для Каждого ВерсияРедмайна ИЗ МассивВерсий Цикл
		НайтиСоздатьВерсию(ВерсияРедмайна);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьСправочникВидовАктивности(МассивВидовАктивности) Экспорт
	
	Для Каждого ВидАктивностиРедмайна ИЗ МассивВидовАктивности Цикл
		НайтиСоздатьВидАктивности(ВидАктивностиРедмайна);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьСправочникКатегорииЗадач(МассивКатегорийЗадач) Экспорт
	
	Для Каждого КатегорияЗадачРедмайна ИЗ МассивКатегорийЗадач Цикл
		НайтиСоздатьКатегориюЗадач(КатегорияЗадачРедмайна);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьСправочникПриоритетов(МассивПриоритетов) Экспорт
	
	Для Каждого ПриоритетРедмайна ИЗ МассивПриоритетов Цикл
		НайтиСоздатьПриоритет(ПриоритетРедмайна);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьСправочникТрекеров(МассивТрекеров) Экспорт
	
	Для Каждого ТрекерРедмайна ИЗ МассивТрекеров Цикл
		НайтиСоздатьТрекер(ТрекерРедмайна);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьСправочникЗадач(МассивЗадач) Экспорт
	
	Для Каждого ЗадачаРедмайна ИЗ МассивЗадач Цикл
		НайтиСоздатьЗадачу(RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ЗадачаРедмайна.id));
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьСправочникТрудозатрат(МассивТрудозатрат) Экспорт
	
	Для Каждого ОтбивкаРедмайна ИЗ МассивТрудозатрат Цикл
		НайтиСоздатьОтбивку(ОтбивкаРедмайна);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСОбъектамиRedmine

Функция НайтиСоздатьПроект(ПроектРедмайна) Экспорт
	
	Проект=Справочники.RA_RedmineПроекты.НайтиПоКоду(RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ПроектРедмайна.id));
	
	Если Не ЗначениеЗаполнено(Проект) Тогда
		
		ПроектОбъект=Справочники.RA_RedmineПроекты.СоздатьЭлемент();
		ПроектОбъект.Код=RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ПроектРедмайна.id);
		ПроектОбъект.Наименование=ПроектРедмайна.name;
		Если ПроектРедмайна.Свойство("identifier") Тогда
			ПроектОбъект.Описание=ПроектРедмайна.description;
			ПроектОбъект.Идентификатор=ПроектРедмайна.identifier;
		КонецЕсли;
		Если ПроектРедмайна.Свойство("parent") Тогда 
			ПроектОбъект.Родитель=НайтиСоздатьПроект(ПроектРедмайна.parent);
		КонецЕсли;
		Если ПроектРедмайна.Свойство("status") Тогда
			ПроектОбъект.Закрыт=ПроектРедмайна.status=5;
		КонецЕсли;
		
		ПроектОбъект.Записать();
		
		Проект=ПроектОбъект.Ссылка;
		
	ИначеЕсли ПроектРедмайна.Свойство("identifier") 
		И (Не ЗначениеЗаполнено(Проект.Идентификатор) 
			ИЛИ Проект.Закрыт И ПроектРедмайна.status=1
			ИЛИ НЕ Проект.Закрыт И ПроектРедмайна.status=5)
		Тогда
			
		ПроектОбъект=Проект.ПолучитьОбъект();
		ПроектОбъект.Описание=ПроектРедмайна.description;
		ПроектОбъект.Идентификатор=ПроектРедмайна.identifier;
		ПроектОбъект.Закрыт=ПроектРедмайна.status=5;
		ПроектОбъект.Записать();
			
	КонецЕсли;
	
	Возврат Проект;
	
КонецФункции

Функция НайтиСоздатьСтатусЗадачи(СтатусРедмайна) Экспорт
	 
	Статус=Справочники.RA_RedmineСтатусы.НайтиПоКоду(RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(СтатусРедмайна.id));
	
	Если Не ЗначениеЗаполнено(Статус) Тогда
		
		СтатусОбъект=Справочники.RA_RedmineСтатусы.СоздатьЭлемент();
		СтатусОбъект.Код=RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(СтатусРедмайна.id);
		СтатусОбъект.Наименование=СтатусРедмайна.name;
		
		СтатусОбъект.Записать();
		
		Статус=СтатусОбъект.Ссылка;
		
	КонецЕсли;
	
	Возврат Статус;
	
КонецФункции

Функция НайтиСоздатьПользователя(ПользовательРедмайна) Экспорт 
	
	Пользователь=Справочники.RA_RedmineПользователи.НайтиПоКоду(RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ПользовательРедмайна.id));
	
	Если Не ЗначениеЗаполнено(Пользователь) Тогда
		ПользовательОбъект=Справочники.RA_RedmineПользователи.СоздатьЭлемент();
		ПользовательОбъект.Код=RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ПользовательРедмайна.id);
		Если ПользовательРедмайна.Свойство("name") Тогда
			ПользовательОбъект.Наименование=ПользовательРедмайна.name;
		Иначе
			ПользовательОбъект.Наименование=ПользовательРедмайна.lastname+" "+ПользовательРедмайна.firstname;
			ПользовательОбъект.Идентификатор=ПользовательРедмайна.login;
		КонецЕсли;
		ПользовательОбъект.Активен = Истина;
		ПользовательОбъект.Записать();
		Пользователь=ПользовательОбъект.Ссылка;
	КонецЕсли;
	
	Возврат Пользователь;
	
КонецФункции

Функция НайтиСоздатьВерсию(ВерсияРедмайна) Экспорт 
	
	Версия=Справочники.RA_RedmineВерсии.НайтиПоКоду(RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ВерсияРедмайна.id));
	
	Если Не ЗначениеЗаполнено(Версия) Тогда
		ВерсияОбъект=Справочники.RA_RedmineВерсии.СоздатьЭлемент();
		ВерсияОбъект.Код=RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ВерсияРедмайна.id);
		ВерсияОбъект.Наименование=ВерсияРедмайна.name;
		ВерсияОбъект.Проект=НайтиСоздатьПроект(ВерсияРедмайна.project);
		ВерсияОбъект.Записать();
		Версия=ВерсияОбъект.Ссылка;
	КонецЕсли;
	
	Возврат Версия;
	
КонецФункции

Функция НайтиСоздатьВидАктивности(ВидАктивностиРедмайна) Экспорт 
	
	ВидАктивности=Справочники.RA_RedmineВидыАктивности.НайтиПоКоду(RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ВидАктивностиРедмайна.id));
	
	Если Не ЗначениеЗаполнено(ВидАктивности) Тогда
		ВидАктивностиОбъект=Справочники.RA_RedmineВидыАктивности.СоздатьЭлемент();
		ВидАктивностиОбъект.Код=RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ВидАктивностиРедмайна.id);
		ВидАктивностиОбъект.Наименование=ВидАктивностиРедмайна.name;
		ВидАктивностиОбъект.Записать();
		ВидАктивности=ВидАктивностиОбъект.Ссылка;
	КонецЕсли;
	
	Возврат ВидАктивности;
	
КонецФункции

Функция НайтиСоздатьКатегориюЗадач(КатегорияЗадачРедмайна) Экспорт 
	
	КатегорияЗадач=Справочники.RA_RedmineКатегорииЗадач.НайтиПоКоду(RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(КатегорияЗадачРедмайна.id));
	
	Если Не ЗначениеЗаполнено(КатегорияЗадач) Тогда
		КатегорияЗадачОбъект=Справочники.RA_RedmineКатегорииЗадач.СоздатьЭлемент();
		КатегорияЗадачОбъект.Код=RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(КатегорияЗадачРедмайна.id);
		КатегорияЗадачОбъект.Наименование=КатегорияЗадачРедмайна.name;
		КатегорияЗадачОбъект.Записать();
		КатегорияЗадач=КатегорияЗадачОбъект.Ссылка;
	КонецЕсли;
	
	Возврат КатегорияЗадач;
	
КонецФункции

Функция НайтиСоздатьПриоритет(ПриоритетРедмайна) Экспорт 
	
	Приоритет=Справочники.RA_RedmineПриоритеты.НайтиПоКоду(RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ПриоритетРедмайна.id));
	
	Если Не ЗначениеЗаполнено(Приоритет) Тогда
		ПриоритетОбъект=Справочники.RA_RedmineПриоритеты.СоздатьЭлемент();
		ПриоритетОбъект.Код=RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ПриоритетРедмайна.id);
		ПриоритетОбъект.Наименование=ПриоритетРедмайна.name;
		ПриоритетОбъект.Записать();
		Приоритет=ПриоритетОбъект.Ссылка;
	КонецЕсли;
	
	Возврат Приоритет;
	
КонецФункции

Функция НайтиСоздатьТрекер(ТрекерРедмайна) Экспорт 
	
	Трекер=Справочники.RA_RedmineТрекеры.НайтиПоКоду(RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ТрекерРедмайна.id));
	
	Если Не ЗначениеЗаполнено(Трекер) Тогда
		ТрекерОбъект=Справочники.RA_RedmineТрекеры.СоздатьЭлемент();
		ТрекерОбъект.Код=RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ТрекерРедмайна.id);
		ТрекерОбъект.Наименование=ТрекерРедмайна.name;
		ТрекерОбъект.Записать();
		Трекер=ТрекерОбъект.Ссылка;
	КонецЕсли;
	
	Возврат Трекер;
	
КонецФункции

Функция НайтиСоздатьЗадачу(ИдентификаторЗадачи, ОбновлятьЗадачу = Истина) Экспорт 
	
	Задача=Справочники.RA_RedmineЗадачи.НайтиПоКоду(ИдентификаторЗадачи);
	
	Если ЗначениеЗаполнено(Задача) И Не ОбновлятьЗадачу Тогда
		Возврат Задача;
	КонецЕсли;
	
	ДанныеПоЗадаче = RA_RedmineПротоколПодключения.ПолучитьДанныеПоЗадаче(,ИдентификаторЗадачи);
		
	Если Не ЗначениеЗаполнено(Задача) Тогда
		ЗадачаОбъект=Справочники.RA_RedmineЗадачи.СоздатьЭлемент();
		ЗадачаОбъект.Код=RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ДанныеПоЗадаче.id);
	Иначе
		ЗадачаОбъект = Задача.ПолучитьОбъект();
	КонецЕсли;
	
	// обновление задачи
	ЗадачаОбъект.Проект = НайтиСоздатьПроект(ДанныеПоЗадаче.project);
	ЗадачаОбъект.Трекер = НайтиСоздатьТрекер(ДанныеПоЗадаче.tracker);
	ЗадачаОбъект.Статус = НайтиСоздатьСтатусЗадачи(ДанныеПоЗадаче.status);
	ЗадачаОбъект.Приоритет = НайтиСоздатьПриоритет(ДанныеПоЗадаче.priority);
	ЗадачаОбъект.Автор = НайтиСоздатьПользователя(ДанныеПоЗадаче.author);
	Если ДанныеПоЗадаче.Свойство("assigned_to") Тогда
		ЗадачаОбъект.Исполнитель = НайтиСоздатьПользователя(ДанныеПоЗадаче.assigned_to);
	Иначе
		ЗадачаОбъект.Исполнитель = ПредопределенноеЗначение("Справочник.RA_RedmineПользователи.ПустаяСсылка");	
	КонецЕсли;
	ЗадачаОбъект.Наименование = ДанныеПоЗадаче.subject;
	Если ДанныеПоЗадаче.Свойство("description") И ЗначениеЗаполнено(ДанныеПоЗадаче.description) Тогда
		ЗадачаОбъект.Описание = ДанныеПоЗадаче.description;
	Иначе
		ЗадачаОбъект.Описание = ДанныеПоЗадаче.subject;
	КонецЕсли;
	Если ДанныеПоЗадаче.Свойство("estimated_hours") Тогда
		ЗадачаОбъект.ОценкаТрудозатрат = ДанныеПоЗадаче.estimated_hours;
	Иначе
		ЗадачаОбъект.ОценкаТрудозатрат = 0;
	КонецЕсли;
	ЗадачаОбъект.ДатаСоздания = ДатаПоЧасовомуПоясуИБ(ДанныеПоЗадаче.created_on);
	ЗадачаОбъект.ДатаОбновления= ДатаПоЧасовомуПоясуИБ(ДанныеПоЗадаче.updated_on);
	Если ДанныеПоЗадаче.Свойство("closed_on") Тогда
		ЗадачаОбъект.ДатаЗакрытия= ДатаПоЧасовомуПоясуИБ(ДанныеПоЗадаче.closed_on);
	Иначе
		ЗадачаОбъект.ДатаЗакрытия = '00010101';
	КонецЕсли;
	Если ДанныеПоЗадаче.Свойство("story_points") Тогда
		ЗадачаОбъект.StoryPoints = ДанныеПоЗадаче.story_points;
	Иначе
		ЗадачаОбъект.StoryPoints = 0;
	КонецЕсли;
	Если ЗадачаОбъект.Проект = RA_RedmineПротоколПодключенияПовтИсп.ПроектПропущенныеЗвонки() Тогда
		ЗадачаОбъект.КонтактОбращения = КонтактОбращенияИзСтрокиСТелефоном(ЗадачаОбъект.Наименование);
	КонецЕсли;
	ЗадачаОбъект.Записать();
	
	Задача=ЗадачаОбъект.Ссылка;
	
	// загрузим изменения
	Если RA_RedmineПротоколПодключенияПовтИсп.ПолучитьПараметрыПодключения().ЗагружатьИзмененияЗадач
		И ДанныеПоЗадаче.Свойство("journals") Тогда
		
		ЗагрузитьИзмененияПоЗадаче(Задача, ДанныеПоЗадаче.journals);
		
	КонецЕсли;
	
	Возврат Задача;
	
КонецФункции

Функция ЗагрузитьИзмененияПоЗадаче(Задача, МассивИзменений)
	
	ЧасовойПоясБазы = ПолучитьЧасовойПоясИнформационнойБазы();
	
	НачатьТранзакцию();
	
	Для Каждого ДанныеИзменения Из МассивИзменений Цикл
		
		ИдентификаторИзменения = RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ДанныеИзменения.id);
		
		Изменение = Справочники.RA_RedmineИзмененияЗадач.НайтиПоКоду(ИдентификаторИзменения,,,Задача);
		
		Если ЗначениеЗаполнено(Изменение) Тогда
			ИзменениеОбъект = Изменение.ПолучитьОбъект();
			ИзменениеОбъект.Состав.Очистить();
		Иначе
			ИзменениеОбъект = Справочники.RA_RedmineИзмененияЗадач.СоздатьЭлемент();
			ИзменениеОбъект.Код = ИдентификаторИзменения;
			ИзменениеОбъект.Владелец = Задача;
		КонецЕсли;
		
		Если ДанныеИзменения.Свойство("user") Тогда
			ИзменениеОбъект.Пользователь = НайтиСоздатьПользователя(ДанныеИзменения.user);
		КонецЕсли;
		Если ДанныеИзменения.Свойство("created_on") Тогда
			ИзменениеОбъект.ДатаСоздания = ДатаПоЧасовомуПоясуИБ(ДанныеИзменения.created_on);
		КонецЕсли;
		Если ДанныеИзменения.Свойство("notes") Тогда
			ИзменениеОбъект.Комментарий = ДанныеИзменения.notes;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ИзменениеОбъект.Комментарий) Тогда
			ИзменениеОбъект.ВидИзменения = Перечисления.RA_RedmineВидыИзмененийЗадач.Комментарий;
		Иначе
			ИзменениеОбъект.ВидИзменения = Перечисления.RA_RedmineВидыИзмененийЗадач.ИзменениеРеквизита;
		КонецЕсли;
		
		Если ДанныеИзменения.Свойство("details") Тогда
			Для Каждого ДетальнаяЗапись Из ДанныеИзменения.details Цикл
				
				НоваяДЗ = ИзменениеОбъект.Состав.Добавить();
				ДетальнаяЗапись.Свойство("property", НоваяДЗ.Свойство);
				ДетальнаяЗапись.Свойство("name", НоваяДЗ.Имя);
				ДетальнаяЗапись.Свойство("old_value", НоваяДЗ.СтароеЗначение);
				ДетальнаяЗапись.Свойство("new_value", НоваяДЗ.НовоеЗначение);
				
				// запишем изменение статуса
				Если НоваяДЗ.Имя = "status_id" Тогда
					
					ЗаписьИсторииСтатусов = РегистрыСведений.RA_RedmineИсторияСтатусовЗадач.СоздатьМенеджерЗаписи();
					ЗаписьИсторииСтатусов.Период = ИзменениеОбъект.ДатаСоздания;
					ЗаписьИсторииСтатусов.Задача = Задача;
					ЗаписьИсторииСтатусов.Пользователь = ИзменениеОбъект.Пользователь;
					ЗаписьИсторииСтатусов.Комментарий = ИзменениеОбъект.Комментарий;
					ЗаписьИсторииСтатусов.Статус = Справочники.RA_RedmineСтатусы.НайтиПоКоду(НоваяДЗ.НовоеЗначение);
					ЗаписьИсторииСтатусов.ПредыдущийСтатус = Справочники.RA_RedmineСтатусы.НайтиПоКоду(НоваяДЗ.СтароеЗначение);
					ЗаписьИсторииСтатусов.Записать();
					
					ИзменениеОбъект.ВидИзменения = Перечисления.RA_RedmineВидыИзмененийЗадач.ИзменениеСтатуса;
					
				КонецЕсли;
				
			КонецЦикла;
		КонецЕсли;
		
		ИзменениеОбъект.Записать();
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
	Возврат Истина;
	
КонецФункции

Функция НайтиСоздатьОтбивку(ОтбивкаРедмайна) Экспорт 
	
	Отбивка=Справочники.RA_RedmineТрудозатраты.НайтиПоКоду(RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ОтбивкаРедмайна.id));
	
	Если Не ЗначениеЗаполнено(Отбивка) Тогда
		ОтбивкаОбъект=Справочники.RA_RedmineТрудозатраты.СоздатьЭлемент();
		ОтбивкаОбъект.Код=RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ОтбивкаРедмайна.id);
	Иначе
		ОтбивкаОбъект = Отбивка.ПолучитьОбъект();		
	КонецЕсли;
	
	Если ОтбивкаРедмайна.Свойство("comments") Тогда
		Описание = ОтбивкаРедмайна.comments
	Иначе
		Описание = "<>";	
	КонецЕсли;
	
	ОтбивкаОбъект.Наименование = Описание;
	
	ОтбивкаОбъект.Описание = Описание;
	
	Если ОтбивкаРедмайна.Свойство("activity") Тогда
		ОтбивкаОбъект.ВидАктивности = НайтиСоздатьВидАктивности(ОтбивкаРедмайна.activity);
	КонецЕсли;
	
	Если ОтбивкаРедмайна.Свойство("updated_on") Тогда
		ОтбивкаОбъект.ДатаОбновления = ДатаПоЧасовомуПоясуИБ(ОтбивкаРедмайна.updated_on);
	КонецЕсли;
	
	Если ОтбивкаРедмайна.Свойство("created_on") Тогда
		ОтбивкаОбъект.ДатаСоздания = ДатаПоЧасовомуПоясуИБ(ОтбивкаРедмайна.created_on);
	КонецЕсли;
	
	Если ОтбивкаРедмайна.Свойство("spent_on") Тогда
		ОтбивкаОбъект.ДатаОтбивки = ДатаПоЧасовомуПоясуИБ(ОтбивкаРедмайна.spent_on);
	КонецЕсли;
	
	Если ОтбивкаРедмайна.Свойство("issue") И ОтбивкаРедмайна.issue.Свойство("id") И ЗначениеЗаполнено(ОтбивкаРедмайна.issue.id) Тогда
		ОтбивкаОбъект.Задача = НайтиСоздатьЗадачу(RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ОтбивкаРедмайна.issue.id), Ложь);
	Иначе
		ОтбивкаОбъект.Задача = ПредопределенноеЗначение("Справочник.RA_RedmineЗадачи.ПустаяСсылка");
	КонецЕсли;
	
	Если ОтбивкаРедмайна.Свойство("hours") Тогда
		ОтбивкаОбъект.КоличествоЧасов = ОтбивкаРедмайна.hours;
	КонецЕсли;
	
	Если ОтбивкаРедмайна.Свойство("user") Тогда
		ОтбивкаОбъект.Пользователь = НайтиСоздатьПользователя(ОтбивкаРедмайна.user);
	КонецЕсли;
	
	Если ОтбивкаРедмайна.Свойство("project") Тогда
		ОтбивкаОбъект.Проект = НайтиСоздатьПроект(ОтбивкаРедмайна.project);
	КонецЕсли;
									
	ОтбивкаОбъект.Записать();
	
	Отбивка=ОтбивкаОбъект.Ссылка;

	Возврат Отбивка;
	
КонецФункции

Функция КонтактОбращенияИзСтрокиСТелефоном(Знач СтрокаСТелефоном)
	
	// пример строки:
	// "Пропущенный звонок от +79777819313 на 74872751074"
	
	УдаляемыеСимволы = " -+()";
	СтрокаСТелефоном = СтрСоединить(СтрРазделить(СтрокаСТелефоном, УдаляемыеСимволы));
	
	РегВыражение = "\d{5,15}";
	Совпадения = РегулярныеВыраженияКлиентСервер.НайтиСовпадения(СтрокаСТелефоном, РегВыражение);
	
	Если НЕ ЗначениеЗаполнено(Совпадения) Тогда
		Возврат ПредопределенноеЗначение("Справочник.ФизическиеЛица.ПустаяСсылка");
	КонецЕсли;
	
	НомерТелефона = Совпадения[0];
	
	Физлицо = ФизическиеЛицаСервер.ФизическоеЛицоПоНомеруТелефона(НомерТелефона);
	
	Возврат Физлицо;
			
КонецФункции

#КонецОбласти

#Область ПолучениеДанныхОбОбъектахRedmine

Функция ВсегоТрудозатратПоЗадаче(ЗадачаСсылка) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ЗадачаСсылка) Тогда
		Возврат 0;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СУММА(RA_RedmineТрудозатраты.КоличествоЧасов) КАК КоличествоЧасов
	|ИЗ
	|	Справочник.RA_RedmineТрудозатраты КАК RA_RedmineТрудозатраты
	|ГДЕ
	|	RA_RedmineТрудозатраты.Задача = &Задача";
	Запрос.УстановитьПараметр("Задача", ЗадачаСсылка);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат 0;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Если НЕ ЗначениеЗаполнено(Выборка.КоличествоЧасов) Тогда
		Возврат 0;
	Иначе
		Возврат Выборка.КоличествоЧасов;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область Служебные

Функция ДатаПоЧасовомуПоясуИБ(ДатаJSON)
	
	ДатаВУнивФормате = УниверсальноеВремя(ПрочитатьДатуJSON(ДатаJSON, ФорматДатыJSON.ISO));
	
	ДатаИБ = МестноеВремя(ДатаВУнивФормате, "Europe/Moscow");
	
	Возврат ДатаИБ;
	
КонецФункции

#КонецОбласти
