import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EditFestivalComponent } from './edit-festival.component';

describe('EditFestivalComponent', () => {
  let component: EditFestivalComponent;
  let fixture: ComponentFixture<EditFestivalComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ EditFestivalComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(EditFestivalComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
