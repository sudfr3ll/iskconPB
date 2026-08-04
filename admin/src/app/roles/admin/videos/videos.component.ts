import { VideosService } from './../../../services/videos.service';
import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { EditVideoComponent } from '../dialogs/edit-video/edit-video.component';
import { Subscription } from 'rxjs';
import { SharedService } from 'src/app/services/shared.service';
import { MatCheckboxChange } from '@angular/material/checkbox';

@Component({
  selector: 'app-videos',
  templateUrl: './videos.component.html',
  styleUrls: ['./videos.component.scss']
})
export class VideosComponent implements OnInit {
  videos: any;
  videosSub: Subscription | undefined;
  showLoader: boolean = true;

  check: boolean = false;
  showHeader: any = false;
  indeterminate = false;
  count: any;

  constructor(
    private dialog: MatDialog,
    private videosService: VideosService,
    public sharedService: SharedService
  ) { }

  async ngOnInit() {
    await this.getVideos()
    this.showLoader = false;

  }

  async getVideos() {
    // this.videos = await this.videosService.getVideos();

    const videos = this.videosService.videos$.getValue();

    if (!videos.length) {
      await this.videosService.getVideos();
    }

    this.videosSub = this.videosService.videos$.subscribe((video: any) => {
      this.videos = video
    })

    console.log(this.videos);
  }


  async editVideo(video: any) {
    const videoClone = JSON.parse(JSON.stringify(video))
    const dialogRef = this.dialog.open(EditVideoComponent, {
      maxWidth: '80%',
      minWidth: 'fit-content',
      data: {
        video: videoClone,
        // categOneData: this.categOneData
        // category
      }
    })

    dialogRef.afterClosed().subscribe(async result => {
      // console.log('result.data',result.data)
      this.showLoader = true;
      await this.getVideos()
      this.showLoader = false;
    });
  }

  async addVideo() {


    const dialogRef = this.dialog.open(EditVideoComponent, {
      maxWidth: '80%',
      minWidth: 'fit-content',

    })

    dialogRef.afterClosed().subscribe(async result => {
      // console.log('result.data',result.data)
      // this.videos.push(result.data)
      console.log(this.videos)

    });
  }

  deleteVideo(id: any) {
    this.sharedService.deleteSingleDoc(id, 'Videos')
  }


  ngOnDestroy() {
    this.videosSub?.unsubscribe();
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
    this.sharedService.openDeleteConfirmationModal('Videos')
    this.showHeader = false;
    this.indeterminate = false
    // this.count = 0
    for (let item of this.videos) {
      item.checked = false;
    }
  }

  getImage(data: any) {
    return this.sharedService.getImage(data)
  }
}
