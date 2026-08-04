import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Subscription } from 'rxjs';
import { QuotesService } from 'src/app/services/quotes.service';
import { EditQuoteComponent } from '../dialogs/edit-quote/edit-quote.component';
import { SharedService } from 'src/app/services/shared.service';
import { MatCheckboxChange } from '@angular/material/checkbox';

@Component({
  selector: 'app-quotes',
  templateUrl: './quotes.component.html',
  styleUrls: ['./quotes.component.scss']
})
export class QuotesComponent implements OnInit {

  quotes: any;
  quotesSub: Subscription | undefined;

  check: boolean = false;
  showHeader: any = false;
  indeterminate = false;
  count: any;

  constructor(
    private quotesService: QuotesService,
    public dialog: MatDialog,
    private sharedService: SharedService
  ) { }

  async ngOnInit() {
  this.getAllQuotes()
  }

  async getAllQuotes(){
    if (!this.quotes) {
      this.quotes = await this.quotesService.getQuotes();
    }

    this.quotes = await this.quotesService.getQuotes();

    const quotes = this.quotesService.quotes$.getValue();

    if (!quotes.length) {
      this.quotesService.getQuotes();
    }

    this.quotesSub = this.quotesService.quotes$.subscribe(quote => {
      this.quotes = quote
    })
  }

  async editQuote(quote: any) {

    const cloneQuote = JSON.parse(JSON.stringify(quote))
    const dialogRef = this.dialog.open(EditQuoteComponent, {
      maxWidth: '80%',
      minWidth: 'fit-content',
      data: {
        quote: cloneQuote
      }
    });

    dialogRef.afterClosed().subscribe(async result => {
      // console.log('result.data',result.data)
      await this.getAllQuotes()
    });
  }

  async addNewQuote() {
    this.dialog.open(EditQuoteComponent, {
      maxWidth: '80%',
      minWidth: '50%'
    });
  }

  deleteQuote(id: any) {
    this.sharedService.deleteSingleDoc(id, 'Quotes')
  }


  ngOnDestroy() {
    this.quotesSub?.unsubscribe();
  }

  onSelectCheckBox(ob: MatCheckboxChange, item: any, data: any) {
    const obj = this.sharedService.onSelectCheckBox(ob, item, data)
    this.showHeader = obj.showHead;
    this.indeterminate = obj.indeterminate
    this.count = obj.count
  }

  onClickSelectAllCheckBox(ob: MatCheckboxChange, data: any) {

    const obj = this.sharedService.onClickSelectAllCheckBox(ob, data)
    this.count = obj.count
    this.showHeader = obj.showHead;
    this.indeterminate = obj.indeterminate
    this.count = obj.count
  }

  onClickCross(data: any) {
    const obj = this.sharedService.onClickCross(data)
    this.showHeader = obj.showHead;
    this.indeterminate = obj.indeterminate
    this.count = obj.count
  }

  openDeleteConfirmationModal(): void {
    this.sharedService.openDeleteConfirmationModal('Quotes')
    this.showHeader = false;
    this.indeterminate = false
    // this.count = 0
    for (let item of this.quotes) {
      item.checked = false;
    }
  }

}
