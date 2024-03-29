
&НаКлиенте
Процедура ЗагрузитьДанные(Команда)
	ЗапуститьФоновоеОбновлениеДанных();
	Элементы.Индикатор.Видимость = Истина;
	ПодключитьОбработчикОжидания("ОбработчикОжидания",1);
КонецПроцедуры

&НаСервере
Процедура ЗапуститьФоновоеОбновлениеДанных()
	АдресХранилища = ПоместитьВоВременноеХранилище(Новый Структура("ТекстЗаголовка,Инд,КоличествоОбходов,ЗакрытьИндикатор","",0,1,Истина),ЭтаФорма.УникальныйИдентификатор);
	МассивПараметров = Новый Массив; 
	МассивПараметров.Добавить(АдресХранилища);
	ФоновыеЗадания.Выполнить("ПроцедурыОбщегоНазначения.ОбновитьДанные",МассивПараметров);	
КонецПроцедуры

&НаСервере
Процедура ЗапуститьФоновоеУдалениеДанных()
	АдресХранилища = ПоместитьВоВременноеХранилище(Новый Структура("ТекстЗаголовка,Инд,КоличествоОбходов,ЗакрытьИндикатор","",0,1,Истина),ЭтаФорма.УникальныйИдентификатор);
	МассивПараметров = Новый Массив; 
	МассивПараметров.Добавить(АдресХранилища);
	ФоновыеЗадания.Выполнить("ПроцедурыОбщегоНазначения.УдалитьДанные",МассивПараметров);	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьДанные(Команда)
	ЗапуститьФоновоеУдалениеДанных();
	Элементы.Индикатор.Видимость = Истина;
	ПодключитьОбработчикОжидания("ОбработчикОжидания",1);
КонецПроцедуры

&НаКлиенте 
Процедура ОбработчикОжидания() Экспорт 
	ДанныеОВыполнении = ПолучитьИзВременногоХранилища(АдресХранилища); 
	Если ТипЗнч(ДанныеОВыполнении) = Тип("Структура") Тогда 
		Элементы.Индикатор.Заголовок = ДанныеОВыполнении.ТекстЗаголовка;
		Индикатор = ДанныеОВыполнении.Инд*100/ДанныеОВыполнении.КоличествоОбходов;
		ЗакрытьИндикатор = ДанныеОВыполнении.ЗакрытьИндикатор;

		Если Индикатор+5 >= 100 Тогда
			Если ЗакрытьИндикатор Тогда
				Элементы.Индикатор.Видимость = Ложь;
				ОтключитьОбработчикОжидания("ОбработчикОжидания");
			КонецЕсли;
			Элементы.Список.Обновить();
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры
