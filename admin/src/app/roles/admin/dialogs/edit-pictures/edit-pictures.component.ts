import { CategoriesService } from 'src/app/services/categories.service';
import { PicturesService } from 'src/app/services/pictures.service';
import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { UtilityService } from 'src/app/services/utility.service';
import { MatSnackBar } from '@angular/material/snack-bar';

@Component({
  selector: 'app-edit-pictures',
  templateUrl: './edit-pictures.component.html',
  styleUrls: ['./edit-pictures.component.scss']
})
export class EditPicturesComponent implements OnInit {

  categories = ['L1', 'L2', 'L3'];
  picturesData: any;
  categoryOneData: any;
  categoryThreeData: any = [];
  categoryTwoData: any = [];
  picture: any;

  showLoader: boolean = false;
  categoryOneId: any;
  categoryTwoId: any;
  categoryThreeId: any;

  categoryOnePictureData: any = [];
  categoryTwoPictureData: any = [];
  categoryThreePictureData: any = [];

  imagesArr: any = [];
  keyword: string = '';

  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    public dialogRef: MatDialogRef<EditPicturesComponent>,
    private picturesService: PicturesService,
    private utilityService: UtilityService,
    private categoriesService: CategoriesService,
    private snackbar: MatSnackBar,
  ) { }

  ngOnInit(): void {
    this.pictureData()

    this.getCategoryOne()
    // this.getCategoryTwo()
    // this.getCategoryThree()


    // console.log('bbbbbbbbbbb',this.categoryTwoDataOfCategoryOne)
  }

  async getCategoryOne() {
    this.categoryOneData = await this.categoriesService.getCategoryOne();
    this.categoryOnePictureData = await this.categoryOneData.filter((data: { type: any; }) => 'pictures' == data.type)

    for (let i = 0; i < this.categoryOnePictureData.length; i++) {
      if (this.picture.categories.includes(this.categoryOnePictureData[i].id)) {
        this.categoryOneId = this.categoryOnePictureData[i].id;
      }
    }


    if (this.categoryOneId) {
      await this.getCategoryTwo(this.categoryOneId);
    }
  }



  async getCategoryTwo(categoryOneId: string) {
    this.categoryTwoData = await this.categoriesService.getCategoryTwoWithId(categoryOneId);
    this.categoryTwoPictureData = await this.categoryTwoData.filter((data: { type: any; }) => 'pictures' == data.type)

    for (let i = 0; i < this.categoryTwoPictureData.length; i++) {
      if (this.picture.categories.includes(this.categoryTwoPictureData[i].id)) {
        this.categoryTwoId = this.categoryTwoPictureData[i].id;
      }
    }


    if (this.categoryTwoId) {
      this.getCategoryThree(this.categoryOneId, this.categoryTwoId);
    }

  }

  async getCategoryThree(categoryOneId: string, categoryTwoId: string) {
    this.categoryThreeData = await this.categoriesService.getCategoryThreeWithId(categoryOneId, categoryTwoId);
    this.categoryThreePictureData = await this.categoryThreeData.filter((data: { type: any; }) => 'pictures' == data.type)

    for (let i = 0; i < this.categoryThreePictureData.length; i++) {
      if (this.picture.categories.includes(this.categoryThreePictureData[i].id)) {
        this.categoryThreeId = this.categoryThreePictureData[i].id;
      }
    }
  }

  async pictureData() {
    if (this.data) {
      this.picture = this.data.picture;
      this.picture['keywords'] = "keywords" in this.picture ? this.picture.keywords : [];
      console.log("this.picture", this.picture)
    }
    else {
      this.picture = {
        title: '',
        description: '',
        categories: [],
        categoryLevel: {},
        image: { thumb: "", org: "", mob: "" },
        keywords: []
      }
    }
  }

  async saveEvent(e: any) {


    console.log("Saving in collection : ,", this.imagesArr)

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

      if (!this.imagesArr || this.imagesArr.length === 0) {
        const picture = { ...this.picture, categories: categoriesId, categoryLevel: { [categoriesId[categoriesId.length - 1]]: categoryLevelVariable } }

        if(!picture.image.org){
          this.snackbar.open('Please upload image', 'OK', { duration: 3000 });
        } else{
          await this.picturesService.updatePicture(picture, this.picture.id); 
          this.snackbar.open('Picture Saved Successfully', 'OK', { duration: 3000 });
          this.dialogRef.close({
            status: 'success'
          });
        }

       
      } else{

        if (this.imagesArr || this.imagesArr.length == 0) {
          if (!this.imagesArr[0]?.org) {
            if (!this.picture.image.org) {
              this.snackbar.open('Please upload image', 'OK', { duration: 3000 });
            }
          } else if (this.imagesArr?.length > 50) {
            this.snackbar.open('Please note : You can only add upto 50 files.', 'OK', { duration: 4000 });
          }
        }

        for (let img of this.imagesArr) {
          console.log("image", img);
          const picture = { ...this.picture, image: img, categories: categoriesId, categoryLevel: { [categoriesId[categoriesId.length - 1]]: categoryLevelVariable } }
          console.log("pictureee", picture);
          await this.picturesService.updatePicture(picture, this.picture.id); 
          this.snackbar.open('Picture Saved Successfully', 'OK', { duration: 3000 });
          this.dialogRef.close({
            status: 'success'
          });   // this.dialogRef.close({ data: this.audio });
          // if (update) {
          //   this.dialogRef.close({ data: { ...this.picture, categories: [categoriesId], categoryLevel: { [categoriesId[categoriesId.length - 1]]: categoryLevelVariable } } });
          // }

        }
      }

     
    
      // this.picture = { ...this.picture, categories: categoriesId, categoryLevel: { [categoriesId[categoriesId.length - 1]]: categoryLevelVariable } }


      e.target.disabled = false;
      this.showLoader = false;
    
  }



  async sendImageEvent(e: any) {

    console.log(e.target.files.length)

    if (e.target.files.length > 0 && e.target.files.length <= 50) {

      console.log('e.target.files', e.target.files)
      for (let i = 0; i < e.target.files.length; i++) {
        console.log('e.target.files', e.target.files[i])

        const imageWithBase64 = await this.utilityService.getBase64FromFile(e.target.files[i]);
        this.imagesArr.push({ org: imageWithBase64 });

      }

      console.log("...................................", this.imagesArr);
    } else {
      this.snackbar.open('Please note : You can only add upto 50 files.', 'OK', { duration: 4000 });

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

  removeImage(index: any) {
    this.imagesArr.splice(index, 1)
  }

  getImage(data: any) {
    console.log('dataaaaaaaa', data)

    for (let i = 0; i < data.length; i++) {
      if (data.image) {
        console.log('resized coverimg')
        return data.image.thumb
      }
    }
    console.log('coverimg')
    return data.org

  }

  removeSingleImage() {
    this.picture.image.org = '';

  }


  addKeyword() {
    const value = (this.keyword || '').trim().toLowerCase();
    console.log("value", value);
    if (value) {
      const index = this.picture.keywords.indexOf(value);
      if (index > -1) {
        this.snackbar.open('Already added', 'OK', { duration: 3000 });
      } else {
        this.picture.keywords.push(value);
      }
    }
    this.keyword = '';
    console.log("keywords", this.picture.keywords);
  }

  removeKeyword(keyword: string) {
    const index = this.picture.keywords.indexOf(keyword);
    if (index > -1) {
      this.picture.keywords.splice(index, 1);
    }
  }


}