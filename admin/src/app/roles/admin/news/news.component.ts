import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { EditNewsComponent } from '../dialogs/edit-news/edit-news.component';
import { NewsService } from 'src/app/services/news.service';
import { Subscription } from 'rxjs';
import { SharedService } from 'src/app/services/shared.service';
import { MatCheckboxChange } from '@angular/material/checkbox';

@Component({
  selector: 'app-news',
  templateUrl: './news.component.html',
  styleUrls: ['./news.component.scss']
})
export class NewsComponent implements OnInit {

  news: any;
  newsSub: Subscription | undefined;
  showLoader: boolean = true;

  check: boolean = false;
  showHeader: any = false;
  indeterminate = false;
  count: any;
  image: any;

  constructor(
    private dialog: MatDialog,
    public newsService: NewsService,
    public sharedService: SharedService

  ) { }

  async ngOnInit(): Promise<void> {
    await this.getAllNews()
    // this.getImage(data)
    this.showLoader = false;
  }

  getImage(data: any){
    return this.sharedService.getImage(data)
  }

  async getAllNews() {
    const news = this.newsService.news$.getValue();
    console.log('news', news)

    if (!news.length) {
      await this.newsService.getNews();
    }

    // this.newsSub = this.newsService.news$.subscribe(new => {
    //   this.news = new
    // })

    this.newsSub = this.newsService.news$.subscribe(msg => {
      this.news = msg

    })

  }

  async addNews() {
    this.dialog.open(EditNewsComponent, {
      maxWidth: '80%',
      minWidth: 'fit-content'
    })


  }

  async editNews(event: any) {
    const cloneNews = JSON.parse(JSON.stringify(event))
    const dialogRef = this.dialog.open(EditNewsComponent, {
      maxWidth: '80%',
      minWidth: 'fit-content',
      data: {
        event: cloneNews
      }
    })

    dialogRef.afterClosed().subscribe(async result => {
      // console.log('result.data',result.data)
      this.showLoader = true;
      await this.getAllNews()
      this.showLoader = false;
    });
  }

  deleteNews(id: any) {
    this.sharedService.deleteSingleDoc(id, 'News')
  }

  ngOnDestroy() {
    this.newsSub?.unsubscribe();
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
    this.sharedService.openDeleteConfirmationModal('News')
    this.showHeader = false;
    this.indeterminate = false
    // this.count = 0
    for (let item of this.news) {
      item.checked = false;
    }
  }





}
