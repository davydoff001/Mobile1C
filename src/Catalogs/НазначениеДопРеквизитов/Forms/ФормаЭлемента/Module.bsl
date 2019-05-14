
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Для Каждого Справочник Из Метаданные.Справочники Цикл
		Если Справочник.Имя = "НазначениеДопРеквизитов" Тогда
			Продолжить;
		КонецЕсли;
		
		СписокОбъектов.Добавить(СокрЛП(Справочник.Имя),СокрЛП(Справочник.Синоним));
	КонецЦикла;
		
КонецПроцедуры

&НаКлиенте
Процедура СправочникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = ЛОЖЬ;
	ДанныеВыбора = Новый СписокЗначений;
	
	Для Каждого ТекСтрока из СписокОбъектов Цикл
		ДанныеВыбора.Добавить(ТекСтрока.Значение);	
	КонецЦикла;
	
	Объект.СправочникНазначение = ТекСтрока.Представление;
	
КонецПроцедуры


&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если НЕ ПроверкаНаПробелы() Тогда		
		ТекстСообщения = "Есть пробелы в именах реквизитов!
		|Убрать пробелы?"; 
		Если Вопрос(ТекстСообщения,РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда 
			Отказ = Истина;	
		Иначе
			УбратьПробелы();
		КонецЕсли;	
	КонецЕсли;
	
	Если ЕстьДубли() Тогда
		Сообщить("Уже существует справочник назначения доп. реквизитов
		|для справочника "+Строка(Объект.СправочникНазначение));
		Отказ = Истина;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Функция ПроверкаНаПробелы() 
	
	Для Каждого ТекСтрока из Объект.ДопРеквизиты Цикл
		Если Найти(ТекСтрока.Реквизит," ") Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
КонецФункции

&НаКлиенте
Процедура УбратьПробелы() 
	
	Для Каждого ТекСтрока из Объект.ДопРеквизиты Цикл
		Если Найти(ТекСтрока.Реквизит," ") Тогда
			ТекСтрока.Реквизит = СтрЗаменить(ТекСтрока.Реквизит," ","");		
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция ЕстьДубли() 
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	НазначениеДопРеквизитов.Ссылка
	               |ИЗ
	               |	Справочник.НазначениеДопРеквизитов КАК НазначениеДопРеквизитов
	               |ГДЕ
	               |	НазначениеДопРеквизитов.СправочникНазначение = &СправочникНазначение
	               |	И НазначениеДопРеквизитов.Ссылка <> &Ссылка"; 
	Запрос.УстановитьПараметр("СправочникНазначение", Объект.СправочникНазначение);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);

	Результат = запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
КонецФункции


