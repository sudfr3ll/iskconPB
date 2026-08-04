import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EditPicturesComponent } from './edit-pictures.component';

describe('EditPicturesComponent', () => {
  let component: EditPicturesComponent;
  let fixture: ComponentFixture<EditPicturesComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ EditPicturesComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(EditPicturesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
