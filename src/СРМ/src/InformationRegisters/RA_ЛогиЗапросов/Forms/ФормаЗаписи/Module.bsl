
&НаСервере
Процедура ОтправитьПовторноНаСервере()
	RA_Запросы.ПовторнаяОтправкаHTTPЗапроса(Запись);
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПовторно(Команда)
	ОтправитьПовторноНаСервере();
КонецПроцедуры
