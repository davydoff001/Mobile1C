
&НаСервере
Процедура ПолучитьНаСервере()
	
	Если НЕ ЗначениеЗаполнено(Объект.Страница) Тогда
		Сообщить("Направление не заполнено!");
		Возврат;
	КонецЕсли;
	
	Объект.Расписание.Очистить();
	
	Файл = КаталогВременныхФайлов()+"swrailway.html";
	Сервер = "swrailway.gov.ua";			
	Соединение = Новый HTTPСоединение(Сервер);			
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("host", Сервер);   		
	Запрос = Новый HTTPЗапрос(Объект.Страница, Заголовки);
	Ответ =Соединение.Получить(Запрос,Файл);
	Если Ответ.КодСостояния = 200 Тогда // Данные получены, обрабатываем их
		ТекстСтраницы= Ответ.ПолучитьТелоКакСтроку();
		ПарсимhtmlСтраницу(Файл);
	Иначе
		Сообщить("Не удалось получить данные с сайта!");
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ПарсимhtmlСтраницу(Файл)
		
	ЧтениеHTMLСтраницы = Новый ЧтениеHTML;
    ЧтениеHTMLСтраницы.ОткрытьФайл(Файл);    
    ПостроительDOM = Новый ПостроительDOM;
    ДокументHTML = ПостроительDOM.Прочитать(ЧтениеHTMLСтраницы);    
    ЭлементыDOM = ДокументHTML.ПолучитьЭлементыПоИмени("td");    
	Естьsh_line  = Ложь;
    ЧтениеДанных = Ложь;
	ДобавитьСтроку = Ложь;
	ДанныеДляЗаполнения  = Неопределено;
	НомерКолонки = 0;
	СоответствиеКолонок = ПолучитьСоответствиеКолонок();
	ДанныеДляЗаполнения = ПолучитьСтруктуруДляЗаполения();
    Для Каждого ТекЭлементDOM Из ЭлементыDOM Цикл       
        Если ТекЭлементDOM.ИмяКласса = "sh_line" Тогда
        	Естьsh_line = Истина;	    
		КонецЕсли;
		
		Если НЕ Естьsh_line Тогда
			Продолжить;
		КонецЕсли;
				
		Если СокрЛП(ТекЭлементDOM.ТекстовоеСодержимое)="по" Тогда
			ЧтениеДанных = Истина;
		КонецЕсли;
		
		Если Не ЧтениеДанных Тогда
			Продолжить;
		КонецЕсли;
		
		Если СокрЛП(ТекЭлементDOM.ТекстовоеСодержимое)="по" Тогда
			Продолжить;
		КонецЕсли;
		
		НомерКолонки = НомерКолонки + 1;
		Если СокрЛП(ТекЭлементDOM.ТекстовоеСодержимое) = "" Тогда
			ДанныеДляЗаполнения = ПолучитьСтруктуруДляЗаполения();
			НомерКолонки = 0;
		КонецЕсли;
		
		Если НомерКолонки = 1 и ДанныеДляЗаполнения<>Неопределено Тогда
			Если НЕ ЭтоЧисло(СокрЛП(ТекЭлементDOM.ТекстовоеСодержимое)) Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
		
		Если НомерКолонки>8 Тогда
			Если ДобавитьСтроку Тогда
				НоваяСтрока = Объект.Расписание.Добавить(); 
				ЗаполнитьЗначенияСвойств(НоваяСтрока,ДанныеДляЗаполнения);
				НоваяСтрока.ДеньНедели = Формат(ТекущаяДата(), "ДФ=""ддд"";Л=uk");
				ДобавитьСтроку = Ложь;
			КонецЕсли;
			Продолжить;
		КонецЕсли;
		
		ИмяКолонки = СоответствиеКолонок.Получить(НомерКолонки);
		Если ИмяКолонки<>Неопределено Тогда
			ДанныеДляЗаполнения[ИмяКолонки]=СокрЛП(ТекЭлементDOM.ТекстовоеСодержимое);
		КонецЕсли;
		
		Если ДанныеДляЗаполнения<>Неопределено и НомерКолонки = 5 Тогда
			Если Объект.ПоказыватьНеОтправленые Тогда
				ТекущаяДата = ТекущаяДата()-300;
				Если СокрЛП(ТекЭлементDOM.ТекстовоеСодержимое)>Формат(ТекущаяДата,"ДФ=""ЧЧ:мм""") Тогда
					ДобавитьСтроку = Истина;	
				КонецЕсли;
			Иначе
				ДобавитьСтроку = Истина;
			КонецЕсли;
		КонецЕсли;
    КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура Получить(Команда)
	ПолучитьНаСервере();
КонецПроцедуры

&НаСервере
Функция ПолучитьСоответствиеКолонок()
	Соответсвие = Новый Соответствие;
	Соответсвие.Вставить(1,"Номер");
	Соответсвие.Вставить(2,"Дни");
	Соответсвие.Вставить(3,"Маршрут");
	Соответсвие.Вставить(5,"Отправление");
	Соответсвие.Вставить(6,"Прибытие");
	Соответсвие.Вставить(8,"ВПути");
	Возврат Соответсвие;
КонецФункции

&НаСервере
Функция ПолучитьСтруктуруДляЗаполения()
	Соответсвие = Новый Структура;
	Соответсвие.Вставить("Номер","");
	Соответсвие.Вставить("Дни","");
	Соответсвие.Вставить("Маршрут","");
	Соответсвие.Вставить("Отправление","");
	Соответсвие.Вставить("Прибытие","");
	Соответсвие.Вставить("ВПути","");
	Возврат Соответсвие;
КонецФункции

&НаСервере
Функция ЭтоЧисло(вхСтрока)
	ЭтоЧисло = Истина;
	
	Для сч=1 по СтрДлина(вхСтрока) Цикл
		Если НЕ (КодСимвола(Сред(вхСтрока,сч,1))>=48 и КодСимвола(Сред(вхСтрока,сч,1))<=57) Тогда
			ЭтоЧисло = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ЭтоЧисло;
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ТекДата = Формат(ТекущаяДата(), "ДФ=""гггг-ММ-дд""");
	Элементы.Направление.СписокВыбора.Добавить("/timetable/eltrain/?gidsid=1&sid=85&sid2=88&startPicker2="+ТекДата+"&dateR=0&lng=#","Святошин-Ирпень");
	Элементы.Направление.СписокВыбора.Добавить("/timetable/eltrain/?gidsid=1&sid=88&sid2=85&startPicker2="+ТекДата+"&dateR=0&lng=#","Ирпень-Святошин");
	Объект.ПоказыватьНеОтправленые = Истина;
	Объект.Страница = "/timetable/eltrain/?gidsid=1&sid=85&sid2=88&startPicker2="+ТекДата+"&dateR=0&lng=#";
	Объект.Направление = Элементы.Направление.СписокВыбора[0];
КонецПроцедуры

&НаКлиенте
Процедура НаправлениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Объект.Страница = ВыбранноеЗначение;
	ВыбранноеЗначение = Элементы.Направление.СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение).Представление;
КонецПроцедуры

&НаКлиенте
Процедура ПоменятьМестами(Команда)
	ТекИндекс = Элементы.Направление.СписокВыбора.Индекс(Элементы.Направление.СписокВыбора.НайтиПоЗначению(Объект.Страница));
	Если ТекИндекс = 0 Тогда
		ТекИндекс = 1;
	Иначе
		ТекИндекс = 0;
	КонецЕсли;
	НовоеНаправление = Элементы.Направление.СписокВыбора.Получить(ТекИндекс);
	Если НовоеНаправление<>Неопределено Тогда
		Объект.Страница = НовоеНаправление.Значение;
		Объект.Направление = НовоеНаправление.Представление;
	КонецЕсли;
	ПолучитьНаСервере();
КонецПроцедуры


&НаКлиенте
Процедура ПоказыватьНеОтправленыеПриИзменении(Элемент)
	ПолучитьНаСервере();
КонецПроцедуры


&НаКлиенте
Процедура Команда1(Команда)
	// Вставить содержимое обработчика.
КонецПроцедуры

