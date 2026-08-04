import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EditSubsriptionTypesComponent } from './edit-subsription-types.component';

describe('EditSubsriptionTypesComponent', () => {
  let component: EditSubsriptionTypesComponent;
  let fixture: ComponentFixture<EditSubsriptionTypesComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ EditSubsriptionTypesComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(EditSubsriptionTypesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
