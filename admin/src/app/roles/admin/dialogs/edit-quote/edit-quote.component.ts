import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { QuotesService } from 'src/app/services/quotes.service';

@Component({
  selector: 'app-edit-quote',
  templateUrl: './edit-quote.component.html',
  styleUrls: ['./edit-quote.component.scss']
})
export class EditQuoteComponent implements OnInit {
  showLoader: boolean = false;
  quote: any = {
    createdAt: '',
    quote: '',
    date: ''
  };
  date: string | undefined;

  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
		public dialogRef: MatDialogRef<EditQuoteComponent>,
    private quotesService: QuotesService,
    private snackbar: MatSnackBar,
  ) { 
    this.dialogRef.disableClose = true;
  }

  async ngOnInit() {
    console.log(this.data)
    if (this.data) {
      this.quote =  this.data.quote;
		}
  }

  async saveQuote(e: any) {
    
    this.quote.date = this.quote.date
    if (!this.quote.quote) {
      this.snackbar.open('Please enter Quote', 'OK', { duration: 3000 });
    } else{
      this.showLoader = true;
      e.target.disabled = true;
      const update = await this.quotesService.updateQuote(this.quote, this.quote.id);
      if (update) {
        this.snackbar.open('Quote Saved Successfully', 'OK', { duration: 3000 });
        this.dialogRef.close();
      }
      e.target.disabled = false;
      this.showLoader = false;
    }
  }

  removeImage() {
    this.quote.coverImage = '';
  }

}
