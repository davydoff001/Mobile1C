
Процедура УстановкаПараметровСеанса(ТребуемыеПараметры)
	#Если МобильноеПриложениеСервер Тогда
	СисИнфо = Новый СистемнаяИнформация;
	Если Найти(СисИнфо.ВерсияОС, "iOS") Тогда
		ПараметрыСеанса.ТекущаяОС = Перечисления.МобильныеОС.iOS;
	ИначеЕсли Найти(СисИнфо.ВерсияОС, "Android") Тогда
		ПараметрыСеанса.ТекущаяОС = Перечисления.МобильныеОС.Android;
	ИначеЕсли Найти(СисИнфо.ВерсияОС, "Windows") ИЛИ Найти(Строка(СисИнфо.ТипПлатформы), "Windows") Тогда
		ПараметрыСеанса.ТекущаяОС = Перечисления.МобильныеОС.Windows;
	КонецЕсли; 
	#Иначе
		ПараметрыСеанса.ТекущаяОС = Перечисления.МобильныеОС.PC;
	#КонецЕсли
КонецПроцедуры