import { SharedService } from './../../../services/shared.service';
import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, NgForm, Validators } from '@angular/forms';
import {MatChipInputEvent} from '@angular/material/chips';
import { MatSnackBar } from '@angular/material/snack-bar';
import { LiveService } from 'src/app/services/live.service';
import { UtilityService } from 'src/app/services/utility.service';

@Component({
  selector: 'app-live-darshan',
  templateUrl: './live-darshan.component.html',
  styleUrls: ['./live-darshan.component.scss']
})
export class LiveDarshanComponent implements OnInit {
  showLoader: boolean = true;
  timing = {
    start: '', 
    end: ''
  };
  darshan: any;
  enable!:boolean
  // darshan: any = [{
  //   title: '',
  //   youtubeId: '',
  //   donationId: '',
  //   coverImage: '',
  //   timings: []
  // }]

  constructor(
    private liveService: LiveService,
    private utilityService: UtilityService,
    private snackbar: MatSnackBar,
    private sharedService: SharedService
  ) { }

  async ngOnInit() {
    const darshan = await this.liveService.getDarshanData();

    this.darshan = darshan;
    this.showLoader = false;

    //  if(!this.darshan.coverImage){
    //   this.darshan.coverImage = `http://img.youtube.com/vi/${darshan.url}/hqdefault.jpg`
    // }
  }

  addTime(time: any) {
    if (!time.start || !time.end) {
      if (!time.start) {
        this.snackbar.open('Please choose start time', 'OK', { duration: 3000 });
      } else if (!time.end) {
        this.snackbar.open('Please choose end time', 'OK', { duration: 3000 });
      } 
    } else {
      this.darshan.timings.push({ start: time.start, end: time.end })
      this.timing = { start: '', end: '' };
    }

  }

  removeTime(index: number) {
    if (index >= 0) {
      this.darshan.timings.splice(index, 1);
    }
  }

  async saveDarshan() {
    if (!this.darshan.coverImage) {
      this.darshan.coverImage = `http://img.youtube.com/vi/${this.darshan.youtubeId}/hqdefault.jpg`
    }

    if (!this.darshan.youtubeId || !this.darshan.coverImage || !this.darshan.title || !this.darshan.timings) {
      if (!this.darshan.youtubeId) {
        this.snackbar.open('Please enter Youtube Id image', 'OK', { duration: 3000 });
      } else if (!this.darshan.coverImage) {
        this.snackbar.open('Please upload cover image', 'OK', { duration: 3000 });
      } else if (!this.darshan.title) {
        this.snackbar.open('Please enter title', 'OK', { duration: 3000 });
      } else if (!this.darshan.timings) {
        this.snackbar.open('Please enter timings', 'OK', { duration: 3000 });
      }
    } else {
      this.showLoader = true;
      if (this.darshan.coverImage.includes('data:image/jpeg;base64,') || this.darshan.coverImage.includes('data:image/jpg;base64,') || this.darshan.coverImage.includes('data:image/png;base64,') || this.darshan.coverImage.includes('data:image/gif;base64,')) {
        this.darshan.coverImage = await this.utilityService.getUrlForUploadedImage(this.darshan.coverImage, `darshan/images/image.png`)
      }

      if (this.darshan.darshanPic.includes('data:image/jpeg;base64,') || this.darshan.darshanPic.includes('data:image/jpg;base64,') || this.darshan.darshanPic.includes('data:image/png;base64,') || this.darshan.coverImage.includes('data:image/gif;base64,')) {
        this.darshan.darshanPic = await this.utilityService.getUrlForUploadedImage(this.darshan.darshanPic, `darshanPics/darshanPic/image.png`)
      }

      const update = await this.liveService.updateDarshan(this.darshan);
      if (update) {
        this.snackbar.open('Submitted Successfully', 'OK', { duration: 3000 });
      }

      this.showLoader = false;
    }

  }

  async sendCoverImageEvent(e: any) {
    if(e.target.files.length>0) {
      const imageWithBase64 = await this.utilityService.getBase64FromFile(e.target.files[0]);
      this.darshan.coverImage = imageWithBase64;
    }
  }

  async sendImageEvent(e: any) {
    if (e.target.files.length > 0) {
      const imageWithBase64 = await this.utilityService.getBase64FromFile(e.target.files[0]);
      this.darshan.darshanPic = imageWithBase64;
    }
  }

  removeImage(){
    this.darshan.darshanPic = ""
  }

  removeCoverImage() {
    this.darshan.coverImage = ""
  }

  onChangeActiveToggle(enable: boolean){
    // onChange(enable: boolean) {
      const field = this.darshan.active;
      if (field == true) {
        field.enable;
      } else {
        field.disable;
      }
      // this.updateText();
    // }
  }

  getImage(data: any) {
    return this.sharedService.getImage(data)
  }
}
