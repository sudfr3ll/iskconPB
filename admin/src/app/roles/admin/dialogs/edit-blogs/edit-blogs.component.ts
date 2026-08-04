import { CategoriesService } from 'src/app/services/categories.service';
// import { BlogsService } from './../../../../services/blogs.service';
// import { Content } from '@angular/compiler/src/render3/r3_ast';
import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { UtilityService } from 'src/app/services/utility.service';
import { BlogsService } from 'src/app/services/blogs.service';
import { MatSnackBar } from '@angular/material/snack-bar';
@Component({
  selector: 'app-edit-blogs',
  templateUrl: './edit-blogs.component.html',
  styleUrls: ['./edit-blogs.component.scss']
})
export class EditBlogsComponent implements OnInit {

  showLoader: boolean = false;
  keyword: string = '';

  categories = ['L1', 'L2', 'L3'];
  categoryOneData: any;
  categoryThreeData: any = [];
  categoryTwoData: any = [];
  categoryOneBlogData: any = [];
  categoryTwoBlogData: any = [];
  categoryThreeBlogData: any = [];
  categoryOneId: any;
  categoryTwoId: any;
  categoryThreeId: any;


  blog: any;
  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    private dialogRef: MatDialogRef<EditBlogsComponent>,
    private utilityService: UtilityService,
    private blogsService: BlogsService,
    private snackbar: MatSnackBar,
    private categoriesService: CategoriesService
  ) {
    this.dialogRef.disableClose = true;
  }

  ngOnInit(): void {

    console.log('this.data', this.data)
    if (this.data) {
      this.blog = this.data.event;
      this.blog['keywords'] = "keywords" in this.blog ? this.blog.keywords : [];
    }
    else {
      this.blog = {
        url: '',
        coverImage: '',
        title: '',
        keywords: []
      }
    }

    this.getCategoryOne()
  }

  async sendImageEvent(e: any) {
    if (e.target.files.length > 0) {
      const imageWithBase64 = await this.utilityService.getBase64FromFile(e.target.files[0]);
      this.blog.coverImage = imageWithBase64;
    }

  }

  async getCategoryOne() {
    this.categoryOneData = await this.categoriesService.getCategoryOne();
    this.categoryOneBlogData = await this.categoryOneData.filter((data: { type: any; }) => 'blogs' == data.type)
    for (let i = 0; i < this.categoryOneBlogData.length; i++) {
      if (this.blog?.categories?.includes(this.categoryOneBlogData[i].id)) {
        this.categoryOneId = this.categoryOneBlogData[i].id;
      }
    }
    if (this.categoryOneId) {
      await this.getCategoryTwo(this.categoryOneId);
    }
  }

  async getCategoryTwo(categoryOneId: string) {
    this.categoryTwoData = await this.categoriesService.getCategoryTwoWithId(categoryOneId);
    this.categoryTwoBlogData = await this.categoryTwoData.filter((data: { type: any; }) => 'blogs' == data.type)

    for (let i = 0; i < this.categoryTwoBlogData.length; i++) {
      if (this.blog?.categories?.includes(this.categoryTwoBlogData[i].id)) {
        this.categoryTwoId = this.categoryTwoBlogData[i].id;
      }
    }


    if (this.categoryTwoId) {
      this.getCategoryThree(this.categoryOneId, this.categoryTwoId);
    }

  }

  async getCategoryThree(categoryOneId: string, categoryTwoId: string) {
    this.categoryThreeData = await this.categoriesService.getCategoryThreeWithId(categoryOneId, categoryTwoId);
    this.categoryThreeBlogData = await this.categoryThreeData.filter((data: { type: any; }) => 'blogs' == data.type)


    for (let i = 0; i < this.categoryThreeBlogData.length; i++) {
      if (this.blog?.categories?.includes(this.categoryThreeBlogData[i].id)) {
        this.categoryThreeId = this.categoryThreeBlogData[i].id;
      }
    }

  }

  async saveBlog(e: any) {
    if ( !this.blog.title || !this.blog.url) {
     if (!this.blog.title) {
        this.snackbar.open('Please enter title', 'OK', { duration: 3000 });
      } else if (!this.blog.url) {
        this.snackbar.open('Please enter url', 'OK', { duration: 3000 });
      }
    }
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

    this.blog = { ...this.blog, categories: categoriesId, categoryLevel: { [categoriesId[categoriesId.length - 1]]: categoryLevelVariable } }
    // this.dialogRef.close({ data: { ...this.audio, categories: [categoriesId], categoryLevel: { [categoriesId]: categoryLevelVariable } } });

    const update = await this.blogsService.updateBlogs(this.blog, this.blog.id);

    // this.dialogRef.close({ data: this.audio });
    if (update) {
      this.snackbar.open('Blog Saved Successfully', 'OK', { duration: 3000 });
      this.dialogRef.close({ data: { ...this.blog, categories: [categoriesId], categoryLevel: { [categoriesId[categoriesId.length - 1]]: categoryLevelVariable } } });
    }
    e.target.disabled = false;
    this.showLoader = false;
  }

    //  else {
    //   this.showLoader = true;
    //   ev.target.disabled = true;
    //   const update = await this.blogsService.updateBlogs(this.blog, this.blog.id);
    //   if (update) {
    //     this.dialogRef.close();

    //   }
    //   ev.target.disabled = false;
    //   this.showLoader = false;

    // }

  

  removeImage() {
    this.blog.coverImage = '';
  }

  addKeyword() {
    const value = (this.keyword || '').trim().toLowerCase();
    console.log("value", value);
    if (value) {
      const index = this.blog.keywords.indexOf(value);
      if (index > -1) {
        this.snackbar.open('Already added', 'OK', { duration: 3000 });
      } else {
        this.blog.keywords.push(value);
      }
    }
    this.keyword = '';
    console.log("keywords", this.blog.keywords);
  }

  removeKeyword(keyword: string) {
    const index = this.blog.keywords.indexOf(keyword);
    if (index > -1) {
      this.blog.keywords.splice(index, 1);
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

}
