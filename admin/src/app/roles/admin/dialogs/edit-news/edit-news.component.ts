import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef,MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { NewsService } from 'src/app/services/news.service';
import { UtilityService } from 'src/app/services/utility.service';
@Component({
  selector: 'app-edit-news',
  templateUrl: './edit-news.component.html',
  styleUrls: ['./edit-news.component.scss']
})
export class EditNewsComponent implements OnInit {
  showLoader: boolean = false;

  news:any;
  // images: any = [];
  keyword: string = '';
  constructor(
    @Inject(MAT_DIALOG_DATA) public data : any,
    private dialogRef : MatDialogRef<EditNewsComponent>,
    private utilityService : UtilityService,
    private newsService : NewsService,
    private snackbar: MatSnackBar,
  ) { }

  ngOnInit(): void {
    if(this.data){
      this.news = this.data.event;
      this.news['keywords'] = "keywords" in this.news ? this.news.keywords : [];
      console.log('this.news',this.news)
      
    }else{
      this.news = {
        coverImage:'',
        content:'',
        title:'',
        newsUrl: ' ',
        images: [],
        keywords: [],
        donationAllowed: false,
      }
    }
  }
  async sendImageEvent(e: any) {

    if(e.target.files.length>0) {
      // const imageWithBase64 = await this.utilityService.getBase64FromFile(e.target.files[0]);
      // this.news.coverImage = imageWithBase64;
      console.log('e.target.files',e.target.files)
      for (let i = 0; i < e.target.files.length; i++) {
        console.log('e.target.files', e.target.files[i])

        const imageWithBase64 = await this.utilityService.getBase64FromFile(e.target.files[i]);
        this.news.images.push({ org: imageWithBase64 });
      }
    }
   
  }

  async saveNews(ev:any){

    if (!this.news.content || !this.news.title) {
      if (!this.news.title) {
        this.snackbar.open('Please upload image', 'OK', { duration: 3000 });
      }
      else if (!this.news.content) {
        this.snackbar.open('Please enter content', 'OK', { duration: 3000 });
      }
    } else{
      console.log(this.news)
      this.showLoader = true;
      ev.target.disabled = true;
      const update = await this.newsService.updateNews(this.news, this.news.id);
      if (update) {
        this.snackbar.open('News Saved Successfully', 'OK', { duration: 3000 });
        console.log('News updated');
        this.dialogRef.close();

      }
      ev.target.disabled = false;
      this.showLoader = false;
    }
  }

  removeImage(index: any) {
    this.news.images.splice(index, 1)
  }

  addKeyword() {
    const value = (this.keyword || '').trim().toLowerCase();
    console.log("value", value);
    if (value) {
      const index = this.news.keywords.indexOf(value);
      if (index > -1) {
        this.snackbar.open('Already added', 'OK', { duration: 3000 });
      } else {
        this.news.keywords.push(value);
      }
    }
    this.keyword = '';
    console.log("keywords", this.news.keywords);
  }

  removeKeyword(keyword: string) {
    const index = this.news.keywords.indexOf(keyword);
    if (index > -1) {
      this.news.keywords.splice(index, 1);
    }
  }

  onChangeDonationAllowed(enable: boolean) {
    const field = this.news.donationAllowed;
    if (field == true) {
      field.enable;
    } else {
      field.disable;
    }
  }

}
