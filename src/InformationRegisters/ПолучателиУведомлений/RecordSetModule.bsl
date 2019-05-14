
Процедура ДобавитьИдентификатор(Пользователь, Идентификатор)
	МенеджерЗаписи = РегистрыСведений.ПолучателиУведомлений.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Получатель = Пользователь;
	МенеджерЗаписи.ИдентификаторПодписчика = Сериализовать(Идентификатор);
	МенеджерЗаписи.Записать();
КонецПроцедуры

Функция ПолучитьИдентификатор(Пользователь) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПолучателиУведомлений.ИдентификаторПодписчика КАК ИдентификаторПодписчика
		|ИЗ
		|	РегистрСведений.ПолучателиУведомлений КАК ПолучателиУведомлений
		|ГДЕ
		|	ПолучателиУведомлений.Получатель = &Получатель";
	
	Запрос.УстановитьПараметр("Получатель", Пользователь);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
		
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	ВыборкаДетальныеЗаписи.Следующий();
	
	Возврат Десериализовать(ВыборкаДетальныеЗаписи.ИдентификаторПодписчика);
КонецФункции

Функция Сериализовать(ОбъектСериализации) Экспорт 
	ДеревоОбъектовXDTO = СериализаторXDTO.ЗаписатьXDTO(ОбъектСериализации);
	МойXML = Новый ЗаписьXML;
	МойXML.УстановитьСтроку();
	ПараметрыЗаписиXML = Новый ПараметрыЗаписиXML("UTF-8","1.0",Ложь);
	ФабрикаXDTO.ЗаписатьXML(МойXML, ДеревоОбъектовXDTO);
	Возврат МойXML.Закрыть();
КонецФункции 

Функция Десериализовать(XMLСтруктураСериализованногоОбъекта) Экспорт 
	ЧтениеXMLДанных = Новый ЧтениеXML;
	ЧтениеXMLДанных.УстановитьСтроку(XMLСтруктураСериализованногоОбъекта);
	ТЗ = СериализаторXDTO.ПрочитатьXML(ЧтениеXMLДанных);
	ЧтениеXMLДанных.Закрыть();
	Возврат ТЗ;
КонецФункции // Десериализовать()
