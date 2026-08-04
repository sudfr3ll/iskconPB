import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { VideosService } from 'src/app/services/videos.service';
import { UtilityService } from 'src/app/services/utility.service';
import { CategoriesService } from 'src/app/services/categories.service';
import { MatSnackBar } from '@angular/material/snack-bar';


@Component({
  selector: 'app-edit-video',
  templateUrl: './edit-video.component.html',
  styleUrls: ['./edit-video.component.scss']
})
export class EditVideoComponent implements OnInit {
  showLoader: boolean = false;

  video: any;

  categories = ['L1', 'L2', 'L3'];
  categoryOneData: any;
  categoryThreeData: any = [];
  categoryTwoData: any = [];
  categoryOneVideoData: any = [];
  categoryTwoVideoData: any = [];
  categoryThreeVideoData: any = [];
  categoryOneId: any;
  categoryTwoId: any;
  categoryThreeId: any;
  keyword: string = '';

  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    public dialogRef: MatDialogRef<EditVideoComponent>,
    private videosService: VideosService,
    private utilityService: UtilityService,
    private categoriesService: CategoriesService,
    private snackbar: MatSnackBar,
  ) { this.dialogRef.disableClose = true; }

  async ngOnInit() {
    this.videosData()
    this.getCategoryOne()

    // if (!this.video.coverImage) {
    //   this.video.coverImage = `http://img.youtube.com/vi/${this.video.url}/hqdefault.jpg`
    // }

  }

  async videosData() {
    if (this.data) {
      this.video = this.data.video;
      this.video['keywords'] = "keywords" in this.video ? this.video.keywords : [];
    }
    else {
      this.video = {
        coverImage: '',
        title: '',
        url: '',
        description: '',
        categories: [],
        categoryLevel: {},
        keywords: []
      }
    }
  }

  async getCategoryOne() {
    this.categoryOneData = await this.categoriesService.getCategoryOne();
    this.categoryOneVideoData = await this.categoryOneData.filter((data: { type: any; }) => 'videos' == data.type)
    for (let i = 0; i < this.categoryOneVideoData.length; i++) {
      if (this.video.categories.includes(this.categoryOneVideoData[i].id)) {
        this.categoryOneId = this.categoryOneVideoData[i].id;
      }
    }
    if (this.categoryOneId) {
      await this.getCategoryTwo(this.categoryOneId);
    }
  }

  async getCategoryTwo(categoryOneId: string) {
    this.categoryTwoData = await this.categoriesService.getCategoryTwoWithId(categoryOneId);
    this.categoryTwoVideoData = await this.categoryTwoData.filter((data: { type: any; }) => 'videos' == data.type)

    for (let i = 0; i < this.categoryTwoVideoData.length; i++) {
      if (this.video.categories.includes(this.categoryTwoVideoData[i].id)) {
        this.categoryTwoId = this.categoryTwoVideoData[i].id;
      }
    }


    if (this.categoryTwoId) {
      this.getCategoryThree(this.categoryOneId, this.categoryTwoId);
    }

  }

  async getCategoryThree(categoryOneId: string, categoryTwoId: string) {
    this.categoryThreeData = await this.categoriesService.getCategoryThreeWithId(categoryOneId, categoryTwoId);
    this.categoryThreeVideoData = await this.categoryThreeData.filter((data: { type: any; }) => 'videos' == data.type)


    for (let i = 0; i < this.categoryThreeVideoData.length; i++) {
      if (this.video.categories.includes(this.categoryThreeVideoData[i].id)) {
        this.categoryThreeId = this.categoryThreeVideoData[i].id;
      }
    }

  }


  async saveEvent(e: any) {

    if(!this.video.coverImage){
      this.video.coverImage = `http://img.youtube.com/vi/${this.video.url}/hqdefault.jpg`
    }

    if (!this.video.title || !this.video.description) {
      if (!this.video.title) {
        this.snackbar.open('Please enter title', 'OK', { duration: 3000 });
      } else if (!this.video.description) {
        this.snackbar.open('Please enter description', 'OK', { duration: 3000 });
      }else if (!this.video.url) {
        this.snackbar.open('Please youtubeId', 'OK', { duration: 3000 });
      }
    } else {
      this.showLoader = true;
      e.target.disabled = true;
      let categoryLevelVariable: any;
      let categoriesId = [];

      if (this.categoryOneId == undefined
      ) {
        categoryLevelVariable = ''
      } else if (this.categoryOneId != undefined && this.categoryTwoId == undefined && this.categoryThreeId == undefined
      ) {

        categoriesId.push(this.categoryOneId)
        categoryLevelVariable = 'L1'

      } else if (this.categoryOneId != undefined
        && this.categoryTwoId != undefined
        && this.categoryThreeId == undefined || this.categoryThreeId == ''
      ) {
        categoriesId.push(...[this.categoryOneId, this.categoryTwoId])
        categoryLevelVariable = 'L2'
      } else if (this.categoryOneId != undefined
        && this.categoryTwoId != undefined
        && this.categoryThreeId != undefined
      ) {
        categoriesId.push(...[this.categoryOneId, this.categoryTwoId, this.categoryThreeId])
        categoryLevelVariable = 'L3'

      }

      this.video = { ...this.video, categories: categoriesId, categoryLevel: { [categoriesId[categoriesId.length - 1]]: categoryLevelVariable } }
      // this.dialogRef.close({ data: { ...this.audio, categories: [categoriesId], categoryLevel: { [categoriesId]: categoryLevelVariable } } });

      const update = await this.videosService.updateVideo(this.video, this.video.id);
     
      // this.dialogRef.close({ data: this.audio });
      if (update) {
        this.snackbar.open('Video Saved Successfully', 'OK', { duration: 3000 });
        this.dialogRef.close({ data: { ...this.video, categories: [categoriesId], categoryLevel: { [categoriesId[categoriesId.length - 1]]: categoryLevelVariable } } });
      }
      e.target.disabled = false;
      this.showLoader = false;
    }



  }

  async sendImageEvent(e: any) {
    if (e.target.files.length > 0) {
      const imageWithBase64 = await this.utilityService.getBase64FromFile(e.target.files[0]);
      this.video.coverImage = imageWithBase64;
    }
  }

  changeCategoryOneName(e: any) {
    this.categoryOneId = e.value
    this.getCategoryTwo(this.categoryOneId)
  }

  changeCategoryTwoName(e: any) {
    this.categoryTwoId = e.value
    this.getCategoryThree(this.categoryOneId, this.categoryTwoId)
  }

  changeCategoryThreeName(e: any) {
    this.categoryThreeId = e.value
  }

  removeImage() {
    this.video.coverImage = '';
  }

  
  addKeyword() {
    const value = (this.keyword || '').trim().toLowerCase();
    console.log("value", value);
    if (value) {
      const index = this.video.keywords.indexOf(value);
      if (index > -1) {
        this.snackbar.open('Already added', 'OK', { duration: 3000 });
      } else {
        this.video.keywords.push(value);
      }
    }
    this.keyword = '';
    console.log("keywords", this.video.keywords);
  }

  removeKeyword(keyword: string) {
    const index = this.video.keywords.indexOf(keyword);
    if (index > -1) {
      this.video.keywords.splice(index, 1);
    }
  }

}
