global function CheckAndShowLanguageDLCDialog

enum eLanguagePackMessage
{
	NOT_OWNED = 0,
	OUT_OF_DATE,
	INSTALLING,
	NO_DOWNLOAD_AVAILABLE,

	_COUNT
}

struct
{
	bool[eLanguagePackMessage._COUNT] seenMessage = [ false, ... ]
} file

void function SeeStoreOptions()
{
	PurchaseCurrentLanguagePack()
}

void function CheckAndShowLanguageDLCDialog()
{
	bool packInstalled = IsLanguagePackInstalled()
	bool packUpToDate = IsLanguagePackUpToDate()
	if ( packInstalled && packUpToDate )
		return;

	int messageToShow = eLanguagePackMessage.NO_DOWNLOAD_AVAILABLE








	{
		if ( !IsLanguagePackOwned() )
		{
			messageToShow = eLanguagePackMessage.NOT_OWNED
		}
		else if ( !packInstalled )
		{
			messageToShow = eLanguagePackMessage.INSTALLING
		}
		else if ( !packUpToDate )
		{
			messageToShow = eLanguagePackMessage.OUT_OF_DATE
		}
	}

	if ( file.seenMessage[messageToShow] )
		return

	printt( "[language_packs] showing message", messageToShow )

	DialogData dlg
	dlg.header = "#LANGUAGE_PACK_NO_DOWNLOAD"
	dlg.message = "#LANGUAGE_PACK_NO_DOWNLOAD_MESSAGE"
	dlg.darkenBackground = true 

	switch ( messageToShow )
	{
		case eLanguagePackMessage.NOT_OWNED:
		{
			string storeName = ""







			dlg.header = "#LANGUAGE_PACK_MISMATCH_HEADER"
			dlg.message = Localize( "#LANGUAGE_PACK_MISMATCH_MESSAGE", storeName )
			AddDialogButton( dlg, "#LANGUAGE_PACK_SEE_OPTIONS", SeeStoreOptions )
			break
		}

		case eLanguagePackMessage.INSTALLING:
		{
			DownloadCurrentLanguagePack() 
			dlg.header = "#LANGUAGE_PACK_INSTALLING_HEADER"
			dlg.message = "#LANGUAGE_PACK_INSTALLING_MESSAGE"
			break
		}

		case eLanguagePackMessage.OUT_OF_DATE:
		{
			dlg.header = "#LANGUAGE_PACK_OUT_OF_DATE_HEADER"
			dlg.message = "#LANGUAGE_PACK_OUT_OF_DATE_MESSAGE"
			AddDialogButton( dlg, "#LANGUAGE_PACK_UPDATE_NOW", DownloadCurrentLanguagePack )
			break
		}
	}

	AddDialogButton( dlg, "#B_BUTTON_CLOSE" )
	OpenDialog( dlg )

	file.seenMessage[messageToShow] = true
}
